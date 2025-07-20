import Foundation

protocol FavoritesViewModelProtocol: ObservableObject {
    var favorites: [FavoriteGameEntity] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var selectedGame: Game? { get set }
    
    func loadFavorites()
    func removeFromFavorites(_ gameID: Int)
    func clearError()
    func selectGame(_ game: Game)
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    @Published var favorites: [FavoriteGameEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedGame: Game?
    
    private let favoritesService: FavoritesServiceProtocol
    
    init(favoritesService: FavoritesServiceProtocol = FavoritesService()) {
        self.favoritesService = favoritesService
    }
    
    func loadFavorites() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.main.async {
            self.favorites = self.favoritesService.fetchFavorites()
            self.isLoading = false
        }
    }
    
    func removeFromFavorites(_ gameID: Int) {
        favoritesService.removeFromFavorites(gameID)
        loadFavorites()
    }
    
    func selectGame(_ game: Game) {
        selectedGame = game
    }
    
    func clearError() {
        errorMessage = nil
    }
}