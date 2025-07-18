import SwiftUI

struct GameListView<Presenter: GameListPresenterProtocol>: View {
    @ObservedObject var presenter: Presenter
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $presenter.searchText)
                    .padding(.horizontal)
                
                if presenter.isLoading && presenter.games.isEmpty {
                    Spacer()
                    ProgressView("Loading games...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
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
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                Spacer()
                            }
                            .padding()
                        }
                    }
                    .refreshable {
                        presenter.refreshGames()
                    }
                }
            }
            .navigationTitle("Games")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("About") {
                        presenter.navigateToAbout()
                    }
                }
            }
            .alert("Error", isPresented: .constant(presenter.errorMessage != nil)) {
                Button("OK") {
                    presenter.clearError()
                }
            } message: {
                Text(presenter.errorMessage ?? "")
            }
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
