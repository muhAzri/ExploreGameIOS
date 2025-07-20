//
//  ContentView.swift
//  ExploreGame
//
//  Created by Azri on 18/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var favoritesCounter = FavoritesCounter()
    @State private var selectedTab = 0
    @StateObject private var gameListViewModel = GameListViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Games Tab
            NavigationStack {
                GameListView()
                    .environmentObject(gameListViewModel)
                    .navigationDestination(item: $gameListViewModel.selectedGame) { game in
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
                FavoritesView()
                    .environmentObject(favoritesViewModel)
                    .navigationDestination(item: $favoritesViewModel.selectedGame) { game in
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
                AboutView()
            }
            .tabItem {
                Image(systemName: "person.circle.fill")
                Text("About")
            }
            .tag(2)
        }
        .onChange(of: gameListViewModel.shouldNavigateToAbout) { _, shouldNavigate in
            if shouldNavigate {
                selectedTab = 2
                gameListViewModel.shouldNavigateToAbout = false
            }
        }
    }
}


#Preview {
    ContentView()
}
