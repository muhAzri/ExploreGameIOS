import Foundation

protocol FavoritesInteractorProtocol {
    func fetchFavorites() -> [FavoriteGameEntity]
    func removeFromFavorites(_ gameID: Int)
}

class FavoritesInteractor: FavoritesInteractorProtocol {
    private let coreDataManager = CoreDataManager.shared
    
    func fetchFavorites() -> [FavoriteGameEntity] {
        let favoriteGames = coreDataManager.fetchFavorites()
        return favoriteGames.map { $0.toEntity() }
    }
    
    func removeFromFavorites(_ gameID: Int) {
        coreDataManager.removeFromFavorites(gameID)
    }
}