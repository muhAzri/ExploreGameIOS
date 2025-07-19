import SwiftUI

struct GameDetailView: View {
    @StateObject private var presenter = SimpleGameDetailPresenter()
    @StateObject private var coreDataManager = CoreDataManager.shared
    @Environment(\.dismiss) private var dismiss
    let game: Game
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text(game.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        if coreDataManager.isFavorite(game.id) {
                            coreDataManager.removeFromFavorites(game.id)
                        } else {
                            coreDataManager.addToFavorites(game)
                            impactFeedback.impactOccurred()
                        }
                    }
                }) {
                    let isFavorite = coreDataManager.isFavorite(game.id)
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .scaleEffect(isFavorite ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFavorite)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            
            // Content
            ScrollView {
                if presenter.isLoading {
                    GameDetailShimmerSkeleton()
                } else if let gameDetail = presenter.gameDetail {
                    GameDetailContent(gameDetail: gameDetail)
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Failed to load game details")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            presenter.loadGameDetail(id: game.id)
        }
        .alert("Error", isPresented: .constant(presenter.errorMessage != nil)) {
            Button("OK") {
                presenter.clearError()
            }
        } message: {
            Text(presenter.errorMessage ?? "")
        }
    }
}

struct GameDetailContent: View {
    let gameDetail: GameDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: gameDetail.backgroundImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.largeTitle)
                    )
            }
            .frame(height: 200)
            .clipped()
            
            VStack(alignment: .leading, spacing: 12) {
                Text(gameDetail.nameOriginal ?? gameDetail.name)
                    .font(.title2)
                    .bold()
                
                HStack {
                    if let released = gameDetail.released {
                        Label(formatDate(released), systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", gameDetail.rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let metacritic = gameDetail.metacritic {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.blue)
                            Text("\(metacritic)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if let platforms = gameDetail.platforms, !platforms.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Platforms")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 100))
                        ], spacing: 8) {
                            ForEach(platforms, id: \.platform.id) { platformInfo in
                                Text(platformInfo.platform.name)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                if let genres = gameDetail.genres, !genres.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Genres")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 80))
                        ], spacing: 8) {
                            ForEach(genres, id: \.id) { genre in
                                Text(genre.name)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                if let esrbRating = gameDetail.esrbRating {
                    HStack {
                        Text("ESRB Rating")
                            .font(.headline)
                        Spacer()
                        Text(esrbRating.name)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                
                if let description = gameDetail.description, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                            .font(.body)
                            .lineLimit(nil)
                    }
                }
                
                if let website = gameDetail.website, !website.isEmpty {
                    if let websiteURL = URL(string: website) {
                        Link("Visit Website", destination: websiteURL)
                            .foregroundColor(.blue)
                            .font(.headline)
                    }
                }
                
                if let redditUrl = gameDetail.redditUrl, !redditUrl.isEmpty {
                    if let redditURL = URL(string: redditUrl) {
                        Link("Reddit Discussion", destination: redditURL)
                            .foregroundColor(.orange)
                            .font(.headline)
                    }
                }
            }
            .padding()
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
