import Foundation
import Combine

struct WebPostsApi: PostsApi {
    private let baseUrl = URL(string: "http://mtaa.test:8888/api/courses")!
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func load(course: Course) -> AnyPublisher<PostsApiResponse, PostsApiError> {
        let request = WebPostsRequest.load.build(baseUrl: baseUrl.appendingPathComponent("\(course.id)"))
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    default: throw PostsApiError.other
                }
            }
            .decode(type: PostsApiResponse.self, decoder: decoder)
            .mapError {error in
                if let apiError = error as? PostsApiError {return apiError}
                else {return PostsApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(course: Course, title: String, category: Category, content: String) -> AnyPublisher<PostsApiResponse, PostsApiError> {
        let request = WebPostsRequest.add(title: title, category: category, content: content)
            .build(baseUrl: baseUrl.appendingPathComponent("\(course.id)"))
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    case .some(422): throw PostsApiError.validationError
                    default: throw AuthApiError.other
                }
            }
            .decode(type: PostsApiResponse.self, decoder: decoder)
            .mapError{ error in
                if let apiError = error as? PostsApiError {return apiError}
                else {return PostsApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum WebPostsRequest {
    case load
    case add(title: String, category: Category, content: String)
}

extension WebPostsRequest: WebRequest {
    var path: String {
        switch self {
            case .load, .add: return "posts"
        }
    }
    
    var method: String {
        switch self {
            case .load: return "GET"
            case .add: return "POST"
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    func body() -> Data? {
        switch self {
            case .load:
                return nil
            case .add(let title, let category, let content):
                return try? JSONEncoder().encode(["title": title, "category_id": "\(category.id)", "content": content])
        }
    }
}
