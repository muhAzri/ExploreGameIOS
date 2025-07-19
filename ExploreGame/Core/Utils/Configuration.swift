import Foundation

struct Configuration {
    static let shared = Configuration()
    
    private init() {}
    
    private var configurationPlist: [String: Any]? {
        guard let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            return nil
        }
        return plist
    }
    
    var apiKey: String {
        if let plist = configurationPlist,
           let apiKey = plist["RAWG_API_KEY"] as? String {
            return apiKey
        }
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "RAWG_API_KEY") as? String {
            return apiKey
        }
        
        fatalError("API Key not found in Configuration.plist or Info.plist")
    }
    
    var baseURL: String {
        if let plist = configurationPlist,
           let baseURL = plist["BASE_URL"] as? String {
            return baseURL
        }
        
        fatalError("Base Url not found in Configuration.plist or Info.plist")
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
