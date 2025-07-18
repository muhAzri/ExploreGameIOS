import Foundation
import Combine

protocol GameListPresenterProtocol: ObservableObject {
    var games: [Game] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var searchText: String { get set }
    
    func loadGames()
    func loadMoreGames()
    func refreshGames()
    func searchGames()
    func clearError()
    func navigateToGameDetail(_ game: Game)
    func navigateToAbout()
}

class GameListPresenter: GameListPresenterProtocol {
    @Published var games: [Game] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private let interactor: GameListInteractorProtocol
    private let router: GameListRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var canLoadMore = true
    
    init(interactor: GameListInteractorProtocol, router: GameListRouterProtocol) {
        self.interactor = interactor
        self.router = router
        
        setupSearchBinding()
    }
    
    func loadGames() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        interactor.fetchGames(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.games = response.results
                    self?.canLoadMore = response.next != nil
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMoreGames() {
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        currentPage += 1
        
        let publisher = searchText.isEmpty ? 
            interactor.fetchGames(page: currentPage) : 
            interactor.searchGames(query: searchText, page: currentPage)
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.games.append(contentsOf: response.results)
                    self?.canLoadMore = response.next != nil
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshGames() {
        games.removeAll()
        loadGames()
    }
    
    func searchGames() {
        guard !searchText.isEmpty else {
            refreshGames()
            return
        }
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        interactor.searchGames(query: searchText, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.games = response.results
                    self?.canLoadMore = response.next != nil
                }
            )
            .store(in: &cancellables)
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.searchGames()
            }
            .store(in: &cancellables)
    }
    
    func navigateToGameDetail(_ game: Game) {
        router.navigateToGameDetail(game)
    }
    
    func navigateToAbout() {
        router.navigateToAbout()
    }
    
    func clearError() {
        errorMessage = nil
    }
}
