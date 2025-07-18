import Foundation
import SwiftUI

protocol GameListRouterProtocol {
    func navigateToGameDetail(_ game: Game)
    func navigateToAbout()
}

class GameListRouter: GameListRouterProtocol {
    func navigateToGameDetail(_ game: Game) {
        NotificationCenter.default.post(name: .navigateToGameDetail, object: game)
    }
    
    func navigateToAbout() {
        NotificationCenter.default.post(name: .navigateToAbout, object: nil)
    }
    
    static func createModule() -> some View {
        let interactor = GameListInteractor()
        let router = GameListRouter()
        let presenter = GameListPresenter(interactor: interactor, router: router)
        let view = GameListView(presenter: presenter)
        
        return view
    }
}
