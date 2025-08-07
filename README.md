# 🔐 Password Manager iOS App

A secure and modern SwiftUI-based password manager application for iOS. Built to demonstrate authentication, encryption, and data persistence best practices.

---

## 📲 Features

- 🔐 Biometric Authentication (Face ID / Touch ID)
- 💾 Secure password storage using Core Data
- 🔑 AES-256 Encryption with CryptoKit
- 🧪 Input validation for email & password strength
- 🧼 Clean SwiftUI interface with sheet presentations
- ➕ Add / Edit / View / Delete password entries
- 🧹 Empty state message when no passwords are saved

---

## 🧰 Tech Stack

- **Swift / SwiftUI** – UI and logic
- **Core Data** – Local persistence
- **CryptoKit** – AES encryption
- **Keychain** – Secure key storage
- **LocalAuthentication** – Biometric security

---

## 🗂 Data Model

`PasswordEntry` (Core Data Entity):

- `id: UUID`
- `accountType: String`
- `username: String`
- `encryptedPassword: Data`
- `dateCreated: Date`
- `dateModified: Date`

---

## 🔐 Security

- AES-256 symmetric encryption
- Encryption key stored securely in Keychain
- Masked password in UI
- Device biometric required to unlock access

---

## 🧪 Input Validation

- All fields are required
- Email must be valid format
- Password must be 8+ characters

---

## 🧭 App Flow

1. App launches and prompts for biometric authentication
2. On success, user can:
    - View stored credentials
    - Add new passwords using a half-sheet
    - Tap on entries to view details
3. Data is encrypted before being stored

---

## 🧑‍💻 About the Developer

Built by an iOS Developer with **3 years of experience** in Swift, SwiftUI, CoreData, and secure app development.

---

## 📸 Screenshots

- Face ID / Unlock screen  
- Password list with floating "+" button  
- Add/Edit form with validation  
- Detail view as half-sheet  

---

## 🚀 Getting Started

1. Clone the repo
2. Open in Xcode
3. Build and run on a real device (Face ID/Touch ID required)
4. Test encryption and add/edit flows

---
