import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading favorites...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.favorites.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Favorite Games")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        Text("Add games to your favorites by tapping the")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "heart")
                                .foregroundColor(.red)
                                .font(.title3)
                            Text("icon in game details")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("You can also see favorite indicators in the Games tab")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.favorites, id: \.gameID) { favorite in
                        FavoriteGameRowView(favorite: favorite) {
                            let coreDataFavorites = CoreDataManager.shared.fetchFavorites()
                            if let favoriteGame = coreDataFavorites.first(where: { Int($0.gameID) == favorite.gameID }) {
                                viewModel.selectGame(favoriteGame.toGame())
                            }
                        } onRemove: {
                            viewModel.removeFromFavorites(favorite.gameID)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.loadFavorites()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

struct FavoriteGameRowView: View {
    let favorite: FavoriteGameEntity
    let onTap: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: favorite.backgroundImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 80)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(favorite.name)
                    .font(.headline)
                    .lineLimit(2)
                
                if let released = favorite.released {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text(formatDate(released))
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", favorite.rating))
                            .font(.caption)
                    }
                    
                    if let metacritic = favorite.metacritic {
                        HStack(spacing: 4) {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                            Text("\(metacritic)")
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.title3)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.string(from: date)
        }
        
        return dateString
    }
}

#Preview {
    FavoritesView()
}