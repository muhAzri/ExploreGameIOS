//
//  ContentView.swift
//  ExploreGame
//
//  Created by Azri on 18/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    @State private var selectedGame: Game?
    @State private var showingAbout = false
    
    var body: some View {
        NavigationStack {
            coordinator.createGameListView()
                .navigationDestination(item: $selectedGame) { game in
                    GameDetailView(game: game)
                }
                .sheet(isPresented: $showingAbout) {
                    NavigationView {
                        coordinator.createAboutView()
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Done") {
                                        showingAbout = false
                                    }
                                }
                            }
                    }
                }
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToGameDetail)) { notification in
            if let game = notification.object as? Game {
                selectedGame = game
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToAbout)) { _ in
            showingAbout = true
        }
    }
}

extension Notification.Name {
    static let navigateToGameDetail = Notification.Name("navigateToGameDetail")
    static let navigateToAbout = Notification.Name("navigateToAbout")
}

#Preview {
    ContentView()
}
