//
//  AESEncryptionHelper.swift
//  ChaintechPractical
//
//  Created by Milan Chhodavadiya on 07/08/25.
//


import SwiftUI
import CryptoKit

struct AESEncryptionHelper {
    static var key: SymmetricKey {
        if let storedKeyData = KeychainHelper.getKey(for: "encryption_key") {
            return SymmetricKey(data: storedKeyData)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            let keyData = newKey.withUnsafeBytes { Data($0) }
            KeychainHelper.saveKey(keyData, for: "encryption_key")
            return newKey
        }
    }

    static func encrypt(_ string: String) throws -> Data {
        let data = Data(string.utf8)
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }

    static func decrypt(_ data: Data) throws -> String {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(decoding: decryptedData, as: UTF8.self)
    }
}
