// NetworkManager using Alamofire for more reliable networking
// To add Alamofire: File -> Add Package Dependencies -> https://github.com/Alamofire/Alamofire
import Foundation
import Combine
import Alamofire

protocol NetworkManagerProtocol {
    func request<T: Codable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError>
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private let apiKey = APIConstants.apiKey
    private let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = Session(configuration: configuration)
    }
    
    func request<T: Codable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = buildURL(from: endpoint) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.request(url)
            .validate()
            .publishData()
            .tryMap { dataResponse in
                if let error = dataResponse.error {
                    throw NetworkError.networkError(error)
                }
                
                guard let data = dataResponse.data else {
                    throw NetworkError.noData
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError
                } else if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func buildURL(from endpoint: APIEndpoint) -> URL? {
        var components = URLComponents(string: endpoint.baseURL + endpoint.path)
        
        var queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        if let parameters = endpoint.parameters {
            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        components?.queryItems = queryItems
        return components?.url
    }
}
