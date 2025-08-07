//
//  PasswordDetailView.swift
//  ChaintechPractical
//
//  Created by Milan Chhodavadiya on 07/08/25.
//

import SwiftUI

struct PasswordDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var entry: PasswordEntry

    @State private var showPassword = false
    @State private var showEditSheet = false
    @State private var errorMessage: String?
    @State private var showDeleteAlert = false

    var body: some View {
        
        VStack(alignment: .leading,spacing: 20) {
            Text("Account Details")
                .font(.headline)
                .foregroundColor(.blue)
            Group {
                Text("Account Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(entry.accountType ?? "")
                    .fontWeight(.bold)
                Text("Username/ Email")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(entry.username ?? "")
                    .font(.body)
                Text("Password")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack {
                    if showPassword {
                        Text(decryptedPassword())
                            .font(.system(.body, design: .monospaced))
                    } else {
                        Text(String(repeating: "*", count: max(6, decryptedPassword().count)))
                            .font(.system(.body, design: .monospaced))
                    }
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            }
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            HStack {
                Button(action: { showEditSheet = true }) {
                    Text("Edit")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(30)
                }
                Button(action: { showDeleteAlert = true }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(30)
                }
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete this account?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteEntry()
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showEditSheet) {
            EditPasswordView(entry: entry) { result in
                if let error = result {
                    errorMessage = error
                } else {
                    showEditSheet = false
                }
            }
            .environment(\.managedObjectContext, viewContext)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private func decryptedPassword() -> String {
        guard let encrypted = entry.encryptedPassword else { return "" }
        do {
            return try AESEncryptionHelper.decrypt(encrypted)
        } catch {
            return ""
        }
    }

    private func deleteEntry() {
        viewContext.delete(entry)
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            errorMessage = "Failed to delete. Try again."
        }
    }
}
