import SwiftUI

struct GameDetailView: View {
    @StateObject private var presenter = SimpleGameDetailPresenter()
    let game: Game
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if presenter.isLoading {
                    ProgressView("Loading game details...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else if let gameDetail = presenter.gameDetail {
                    GameDetailContent(gameDetail: gameDetail)
                } else {
                    Text("Failed to load game details")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            }
        }
        .navigationTitle(game.name)
        .navigationBarTitleDisplayMode(.inline)
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
                    Link("Visit Website", destination: URL(string: website)!)
                        .foregroundColor(.blue)
                        .font(.headline)
                }
                
                if let redditUrl = gameDetail.redditUrl, !redditUrl.isEmpty {
                    Link("Reddit Discussion", destination: URL(string: redditUrl)!)
                        .foregroundColor(.orange)
                        .font(.headline)
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