# Password Manager iOS App

A secure and modern SwiftUI-based password manager application for iOS. Built to demonstrate authentication, encryption, and data persistence best practices.

---

## 📲 Features

- Biometric Authentication (Face ID / Touch ID)
- Secure password storage using Core Data
- AES-256 Encryption with CryptoKit
- Input validation for email & password strength
- Clean SwiftUI interface with sheet presentations
- Add / Edit / View / Delete password entries
- Empty state message when no passwords are saved

---

## Tech Stack

- **Swift / SwiftUI** – UI and logic
- **Core Data** – Local persistence
- **CryptoKit** – AES encryption
- **Keychain** – Secure key storage
- **LocalAuthentication** – Biometric security

---

## Data Model

PasswordEntry (Core Data Entity):

- id: UUID
- accountType: String
- username: String
- encryptedPassword: Data
- dateCreated: Date
- dateModified: Date

---

## Security

- AES-256 symmetric encryption
- Encryption key stored securely in Keychain
- Masked password in UI
- Device biometric required to unlock access

---

## Input Validation

- All fields are required
- Email must be valid format
- Password must be 8+ characters

---

## App Flow

1. App launches and prompts for biometric authentication
2. On success, user can:
    - View stored credentials
    - Add new passwords using a half-sheet
    - Tap on entries to view details
3. Data is encrypted before being stored

---

## Getting Started

### Prerequisites

- Xcode 15 or later
- iOS 16.0+ device (biometric hardware required)
- Swift 5.9+

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/password-manager-ios.git
   ```

2. Open the project in Xcode:
   ```bash
   open PasswordManager.xcodeproj
   ```

3. Select a real iOS device (Face ID / Touch ID required) from the device list.

4. Build and run the app:
   - Use `Cmd + R` or click the ▶️ run button.

### Using the App

- On first launch, you'll be prompted to authenticate with Face ID / Touch ID.
- After successful authentication:
  - Tap the ➕ button to add a new password.
  - Fill out all fields (account, email, password) and save.
  - Passwords are masked in the list and stored securely.
  - Tap on an item to view details.
  - Swipe to delete any saved entry.
