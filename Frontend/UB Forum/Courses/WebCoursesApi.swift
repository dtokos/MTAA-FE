import Foundation
import Combine

struct WebCoursesApi: CoursesApi {
    private let baseUrl = URL(string: "http://mtaa.test:8888/api/courses")!
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func load() -> AnyPublisher<CoursesApiResponse, CoursesApiError> {
        let request = WebCoursesRequest.load.build(baseUrl: baseUrl)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    default: throw CoursesApiError.other
                }
            }
            .decode(type: CoursesApiResponse.self, decoder: decoder)
            .mapError {error in
                if let apiError = error as? CoursesApiError {return apiError}
                else {return CoursesApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum WebCoursesRequest {
    case load
}

extension WebCoursesRequest: WebRequest {
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
