//
//  PasswordStrengthView.swift
//  ChaintechPractical
//
//  Created by Milan Chhodavadiya on 07/08/25.
//

import SwiftUI

struct PasswordStrengthView: View {
    let password: String
    var strength: Int {
        var score = 0
        if password.count >= 8 { score += 1 }
        if password.rangeOfCharacter(from: .uppercaseLetters) != nil { score += 1 }
        if password.rangeOfCharacter(from: .lowercaseLetters) != nil { score += 1 }
        if password.rangeOfCharacter(from: .decimalDigits) != nil { score += 1 }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")) != nil { score += 1 }
        return score
    }
    var color: Color {
        switch strength {
        case 0...2: return .red
        case 3: return .orange
        case 4: return .yellow
        default: return .green
        }
    }
    var body: some View {
        HStack {
            Text("Strength:")
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: CGFloat(strength) * 30, height: 8)
            Spacer()
        }
        .padding(.top, 4)
    }
}
