import Foundation

struct Configuration {
    static let shared = Configuration()
    
    private init() {}
    
    var apiKey: String {
        // In production, this should come from:
        // 1. Environment variables
        // 2. Secure keychain storage
        // 3. Server-side configuration
        // 4. Info.plist (for development only)
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "RAWG_API_KEY") as? String {
            return apiKey
        }
        
        // Fallback for development (should be removed in production)
        return "bb59da7d47634570b63f0261386b145a"
    }
    
    var baseURL: String {
        return "https://api.rawg.io/api"
    }
}

// MARK: - Development Configuration
extension Configuration {
    var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    func logNetworkRequests(_ enabled: Bool = true) {
        // This could be used to toggle network logging
    }
}