//
//  EditPasswordView.swift
//  ChaintechPractical
//
//  Created by Milan Chhodavadiya on 07/08/25.
//

import SwiftUI

struct EditPasswordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var entry: PasswordEntry
    var onComplete: (String?) -> Void

    @State private var accountType: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Account")
                .font(.headline)
                .padding(.top, 32)
            TextField("Account Name", text: $accountType)
                .padding(.vertical, 14)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            TextField("Username/ Email", text: $username)
                .keyboardType(.emailAddress)
                .padding(.vertical, 14)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
            HStack {
                if showPassword {
                    TextField("Password", text: $password)
                        .padding(.vertical, 14)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                } else {
                    SecureField("Password", text: $password)
                        .padding(.vertical, 14)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                }
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            PasswordStrengthView(password: password)
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            Button(action: save) {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(30)
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        .onAppear {
            accountType = entry.accountType ?? ""
            username = entry.username ?? ""
            if let encrypted = entry.encryptedPassword {
                password = (try? AESEncryptionHelper.decrypt(encrypted)) ?? ""
            }
        }
    }

    private func save() {
        errorMessage = nil
        let trimmedAccount = accountType.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedAccount.isEmpty, !trimmedUsername.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "All fields are required."
            onComplete(errorMessage)
            return
        }

        guard isValidEmail(trimmedUsername) else {
            errorMessage = "Please enter a valid email address."
            onComplete(errorMessage)
            return
        }

        guard trimmedPassword.count >= 8 else {
            errorMessage = "Password must be at least 8 characters long."
            onComplete(errorMessage)
            return
        }

        do {
            entry.accountType = trimmedAccount
            entry.username = trimmedUsername
            entry.encryptedPassword = try AESEncryptionHelper.encrypt(trimmedPassword)
            entry.dateModified = Date()
            try viewContext.save()
            onComplete(nil)
            presentationMode.wrappedValue.dismiss()
        } catch {
            errorMessage = "Failed to save. Try again."
            onComplete(errorMessage)
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
