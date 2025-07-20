import SwiftUI

struct GameListView: View {
    @EnvironmentObject var viewModel: GameListViewModel
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            
            if viewModel.isLoading && viewModel.games.isEmpty {
                ScrollView {
                    GameListShimmerSkeleton()
                }
            } else if viewModel.games.isEmpty {
                Spacer()
                Text("No games found")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.games) { game in
                        GameRowView(game: game)
                            .onTapGesture {
                                viewModel.selectGame(game)
                            }
                            .onAppear {
                                if game.id == viewModel.games.last?.id {
                                    viewModel.loadMoreGames()
                                }
                            }
                    }
                    
                    if viewModel.isLoading && !viewModel.games.isEmpty {
                        GameRowShimmerSkeleton()
                            .padding(.horizontal)
                    }
                }
                .refreshable {
                    viewModel.refreshGames()
                }
            }
        }
        .navigationTitle("Games")
        .navigationBarTitleDisplayMode(.large)
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onAppear {
            if viewModel.games.isEmpty {
                viewModel.loadGames()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search games...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
