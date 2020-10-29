//
//  LanguageWordBuilderApp.swift
//  LanguageWordBuilder
//
//  Created by Jonathan Gurr on 28-09-20.
//

import SwiftUI

@main
struct LanguageWordBuilderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
					ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
