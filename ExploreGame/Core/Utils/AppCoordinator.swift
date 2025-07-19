import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var selectedTab = 0
    
    func createGameListView() -> some View {
        GameListRouter.createModule()
    }
    
    func createAboutView() -> some View {
        AboutRouter.createModule()
    }
    
    func createFavoritesView() -> some View {
        FavoritesView()
    }
}
