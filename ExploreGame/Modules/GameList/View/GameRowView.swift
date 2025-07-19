import SwiftUI

struct GameRowView: View {
    let game: Game
    @StateObject private var coreDataManager = CoreDataManager.shared
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: game.backgroundImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 60)
            .clipped()
            .cornerRadius(8)
            .overlay(
                // Favorite indicator in top-right corner of image
                Group {
                    let isFavorite = coreDataManager.isFavorite(game.id)
                    if isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                }
                .offset(x: 6, y: -6),
                alignment: .topTrailing
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(game.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    if let released = game.released {
                        Text(formatDate(released))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", game.rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .contextMenu {
            let isFavorite = coreDataManager.isFavorite(game.id)
            Button(action: {
                if isFavorite {
                    coreDataManager.removeFromFavorites(game.id)
                } else {
                    coreDataManager.addToFavorites(game)
                }
            }) {
                Label(
                    isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    systemImage: isFavorite ? "heart.slash" : "heart"
                )
            }
        }
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
