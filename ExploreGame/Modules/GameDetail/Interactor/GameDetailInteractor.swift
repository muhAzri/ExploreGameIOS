import Foundation
import Combine

protocol GameDetailInteractorProtocol {
    func fetchGameDetail(id: Int) -> AnyPublisher<GameDetail, NetworkError>
}

class GameDetailInteractor: GameDetailInteractorProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchGameDetail(id: Int) -> AnyPublisher<GameDetail, NetworkError> {
        networkManager.request(.gameDetail(id: id))
    }
}
