import Foundation
import Combine

protocol GameDetailPresenterProtocol: ObservableObject {
    var gameDetail: GameDetail? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadGameDetail(id: Int)
    func clearError()
}

class GameDetailPresenter: GameDetailPresenterProtocol {
    @Published var gameDetail: GameDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let interactor: GameDetailInteractorProtocol
    private let router: GameDetailRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(interactor: GameDetailInteractorProtocol, router: GameDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    deinit {
    }
    
    func loadGameDetail(id: Int) {
        isLoading = true
        errorMessage = nil
        
        interactor.fetchGameDetail(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] gameDetail in
                    self?.gameDetail = gameDetail
                }
            )
            .store(in: &cancellables)
    }
    
    func clearError() {
        errorMessage = nil
    }
}
