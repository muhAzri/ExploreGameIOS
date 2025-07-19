//
//  ExploreGameApp.swift
//  ExploreGame
//
//  Created by Azri on 18/07/25.
//

import SwiftUI

@main
struct ExploreGameApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
