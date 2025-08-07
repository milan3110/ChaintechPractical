//
//  ContentView.swift
//  ChaintechPractical
//
//  Created by Milan Chhodavadiya on 07/08/25.
//

import SwiftUI
import CoreData
import LocalAuthentication

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PasswordEntry.dateCreated, ascending: false)],
        animation: .default)
    private var passwords: FetchedResults<PasswordEntry>

    @State private var showAddSheet = false
    @State private var selectedPassword: PasswordEntry?
    @State private var isUnlocked = false
    @State private var authError: String?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if isUnlocked {
                    NavigationView {
                        Group {
                            if passwords.isEmpty {
                                Text("No passwords saved yet.\nTap + to add your first password.")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray)
                                    .font(.headline)
                                    .padding()
                            } else {
                                List {
                                    ForEach(passwords) { entry in
                                        Button(action: {
                                            selectedPassword = entry
                                        }) {
                                            HStack {
                                                Text(entry.accountType ?? "Account")
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.black)
                                                Text(maskedPassword(entry))
                                                    .font(.system(.body, design: .monospaced))
                                                    .foregroundColor(.gray)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundColor(.gray)
                                                    .padding(.leading, 8)
                                            }
                                            .padding(16)
                                            .background(Color.white)
                                            .cornerRadius(30)
                                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .listRowBackground(Color.clear)
                                        .padding(.vertical, 4)
                                        .listRowSeparator(.hidden)
                                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                                    }
                                    .onDelete(perform: deletePasswords)
                                }
                                .scrollContentBackground(.hidden)
                                .listRowSeparator(.hidden)
                                .background(Color.clear)
                                .listStyle(PlainListStyle())
                                .environment(\.defaultMinListRowHeight, 0)
                                .environment(\.colorScheme, .light)
                            }
                        }
                        .navigationTitle("Password Manager")
                        .navigationBarTitleDisplayMode(.inline)
                        .sheet(item: $selectedPassword, onDismiss: { selectedPassword = nil }) { entry in
                            PasswordDetailView(entry: entry)
                                .environment(\.managedObjectContext, viewContext)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)
                        }
                        .sheet(isPresented: $showAddSheet) {
                            AddPasswordView()
                                .environment(\.managedObjectContext, viewContext)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.visible)
                        }
                    }
                } else {
                    VStack(spacing: 24) {
                        Spacer()
                        Image(systemName: "lock.shield")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                        Text("Unlock Password Manager")
                            .font(.title2)
                            .fontWeight(.semibold)
                        if let error = authError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        Button(action: authenticate) {
                            Text("Unlock with Face ID / Touch ID")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .onAppear(perform: authenticate)
                }
            }

            if isUnlocked {
                Button(action: { showAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
        }
    }

    private func maskedPassword(_ entry: PasswordEntry) -> String {
        guard let encrypted = entry.encryptedPassword else { return "******" }
        do {
            let decrypted = try AESEncryptionHelper.decrypt(encrypted)
            return String(repeating: "*", count: max(6, decrypted.count))
        } catch {
            return "******"
        }
    }

    private func deletePasswords(offsets: IndexSet) {
        withAnimation {
            offsets.map { passwords[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Handle error
            }
        }
    }

    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        let reason = "Authenticate to access your passwords."
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                        self.authError = nil
                    } else {
                        self.authError = "Authentication failed. Try again."
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.authError = "Biometric authentication not available."
            }
        }
    }
}
