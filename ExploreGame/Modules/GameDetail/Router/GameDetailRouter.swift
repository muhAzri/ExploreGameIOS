import Foundation
import SwiftUI

protocol GameDetailRouterProtocol {
}

class GameDetailRouter: GameDetailRouterProtocol {
    static func createModule(game: Game) -> some View {
        let interactor = GameDetailInteractor()
        let router = GameDetailRouter()
        let presenter = GameDetailPresenter(interactor: interactor, router: router)
        
        return GameDetailViewWrapper(presenter: presenter, game: game)
    }
}

struct GameDetailViewWrapper<Presenter: GameDetailPresenterProtocol>: View {
    @StateObject var presenter: Presenter
    let game: Game
    
    init(presenter: Presenter, game: Game) {
        self._presenter = StateObject(wrappedValue: presenter)
        self.game = game
    }
    
    var body: some View {
        GameDetailView(game: game)
    }
}
