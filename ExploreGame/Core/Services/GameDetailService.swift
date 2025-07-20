import Foundation
import Combine

protocol GameDetailServiceProtocol {
    func fetchGameDetail(id: Int) -> AnyPublisher<GameDetail, NetworkError>
}

class GameDetailService: GameDetailServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchGameDetail(id: Int) -> AnyPublisher<GameDetail, NetworkError> {
        networkManager.request(.gameDetail(id: id))
    }
}
