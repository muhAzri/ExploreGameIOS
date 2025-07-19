import Foundation

protocol FavoritesRouterProtocol {
    func navigateToGameDetail(game: Game)
}

class FavoritesRouter: ObservableObject, FavoritesRouterProtocol {
    func navigateToGameDetail(game: Game) {
        NotificationCenter.default.post(name: .navigateToGameDetail, object: game)
    }
}