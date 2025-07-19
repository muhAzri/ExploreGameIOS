//
//  ContentView.swift
//  ExploreGame
//
//  Created by Azri on 18/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var favoritesCounter = FavoritesCounter()
    @State private var selectedGame: Game?
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Games Tab
            NavigationStack {
                coordinator.createGameListView()
                    .navigationDestination(item: $selectedGame) { game in
                        GameDetailView(game: game)
                    }
            }
            .tabItem {
                Image(systemName: "gamecontroller.fill")
                Text("Games")
            }
            .tag(0)
            
            // Favorites Tab
            NavigationStack {
                coordinator.createFavoritesView()
                    .navigationDestination(item: $selectedGame) { game in
                        GameDetailView(game: game)
                    }
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            .tag(1)
            .badge(favoritesCounter.count)
            
            // About Tab
            NavigationStack {
                coordinator.createAboutView()
            }
            .tabItem {
                Image(systemName: "person.circle.fill")
                Text("About")
            }
            .tag(2)
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToGameDetail)) { notification in
            if let game = notification.object as? Game {
                selectedGame = game
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToAbout)) { _ in
            selectedTab = 2
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToFavorites)) { _ in
            selectedTab = 1
        }
    }
}

extension Notification.Name {
    static let navigateToGameDetail = Notification.Name("navigateToGameDetail")
    static let navigateToAbout = Notification.Name("navigateToAbout")
    static let navigateToFavorites = Notification.Name("navigateToFavorites")
}

#Preview {
    ContentView()
}
