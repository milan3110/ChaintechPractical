//
//  AddPasswordView.swift
//  ChaintechPractical
//
//  Created by Milan Chhodavadiya on 07/08/25.
//

import SwiftUI

struct AddPasswordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var accountType = ""
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
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
                Button(action: { password = generatePassword() }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.blue)
                        .help("Generate strong password")
                }
            }
            PasswordStrengthView(password: password)
            if let error = errorMessage {
                Text(error).foregroundColor(.red).font(.caption)
            }
            Button(action: save) {
                Text("Add New Account")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.black)
                    .cornerRadius(30)
            }
        }
        .padding()
    }

    private func save() {
        errorMessage = nil
        let trimmedAccount = accountType.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedAccount.isEmpty, !trimmedUsername.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        guard isValidEmail(trimmedUsername) else {
            errorMessage = "Please enter a valid email address."
            return
        }

        guard trimmedPassword.count >= 8 else {
            errorMessage = "Password must be at least 8 characters long."
            return
        }

        do {
            let encrypted = try AESEncryptionHelper.encrypt(trimmedPassword)
            let entry = PasswordEntry(context: viewContext)
            entry.id = UUID()
            entry.accountType = trimmedAccount
            entry.username = trimmedUsername
            entry.encryptedPassword = encrypted
            entry.dateCreated = Date()
            entry.dateModified = Date()
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            errorMessage = "Failed to save. Try again."
        }
    }

    private func generatePassword() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?"
        return String((0..<14).map { _ in chars.randomElement()! })
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
