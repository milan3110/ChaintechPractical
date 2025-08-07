//
//  ChaintechPracticalApp.swift
//  ChaintechPractical
//
//  Created by Milan Chhodavadiya on 07/08/25.
//

import SwiftUI
import CoreData
import CryptoKit

@main
struct ChaintechPracticalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
