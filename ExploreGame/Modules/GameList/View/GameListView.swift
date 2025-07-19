import SwiftUI

struct GameListView<Presenter: GameListPresenterProtocol>: View {
    @ObservedObject var presenter: Presenter
    
    var body: some View {
        VStack {
            SearchBar(text: $presenter.searchText)
                .padding(.horizontal)
            
            if presenter.isLoading && presenter.games.isEmpty {
                ScrollView {
                    GameListShimmerSkeleton()
                }
            } else if presenter.games.isEmpty {
                Spacer()
                Text("No games found")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(presenter.games) { game in
                        GameRowView(game: game)
                            .onTapGesture {
                                presenter.navigateToGameDetail(game)
                            }
                            .onAppear {
                                if game.id == presenter.games.last?.id {
                                    presenter.loadMoreGames()
                                }
                            }
                    }
                    
                    if presenter.isLoading && !presenter.games.isEmpty {
                        GameRowShimmerSkeleton()
                            .padding(.horizontal)
                    }
                }
                .refreshable {
                    presenter.refreshGames()
                }
            }
        }
        .navigationTitle("Games")
        .navigationBarTitleDisplayMode(.large)
        .alert("Error", isPresented: .constant(presenter.errorMessage != nil)) {
            Button("OK") {
                presenter.clearError()
            }
        } message: {
            Text(presenter.errorMessage ?? "")
        }
        .onAppear {
            if presenter.games.isEmpty {
                presenter.loadGames()
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
