import Foundation
import SwiftUI

protocol AboutRouterProtocol {
}

class AboutRouter: AboutRouterProtocol {
    static func createModule() -> some View {
        let router = AboutRouter()
        let presenter = AboutPresenter(router: router)
        let view = AboutView(presenter: presenter)
        
        return view
    }
}
