import Foundation
import Combine

struct WebCategoriesApi: CategoriesApi {
    private let baseUrl = URL(string: "http://mtaa.test:8888/api/categories")!
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func load() -> AnyPublisher<CategoriesApiResponse, CategoriesApiError> {
        let request = WebCategoriesRequest.load.build(baseUrl: baseUrl)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    default: throw CategoriesApiError.other
                }
            }
            .decode(type: CategoriesApiResponse.self, decoder: decoder)
            .mapError {error in
                if let apiError = error as? CategoriesApiError {return apiError}
                else {return CategoriesApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum WebCategoriesRequest {
    case load
}

extension WebCategoriesRequest: WebRequest {
    var path: String {
        return ""
    }
    
    var method: String {
        return "GET"
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    func body() -> Data? {
        return nil
    }
}
