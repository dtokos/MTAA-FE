import Foundation
import Combine

struct WebCommentsApi: CommentsApi {
    private let baseUrl = URL(string: "http://mtaa.test:8888/api/courses")!
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func load(post: Post) -> AnyPublisher<CommentsApiResponse, CommentsApiError> {
        let request = WebCommentsRequest.load
            .build(baseUrl: baseUrl.appendingPathComponent("\(post.courseId)/posts/\(post.id)"))
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    default: throw CommentsApiError.other
                }
            }
            .decode(type: CommentsApiResponse.self, decoder: decoder)
            .mapError {error in
                if let apiError = error as? CommentsApiError {return apiError}
                else {return CommentsApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(post: Post, content: String) -> AnyPublisher<CommentsApiResponse, CommentsApiError> {
        let request = WebCommentsRequest.add(content: content)
            .build(baseUrl: baseUrl.appendingPathComponent("\(post.courseId)/posts/\(post.id)"))
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    case .some(422): throw CommentsApiError.validationError
                    default: throw CommentsApiError.other
                }
            }
            .decode(type: CommentsApiResponse.self, decoder: decoder)
            .mapError{error in
                if let apiError = error as? CommentsApiError {return apiError}
                else {return CommentsApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func edit(post: Post, comment: Comment) -> AnyPublisher<CommentsApiResponse, CommentsApiError> {
        let request = WebCommentsRequest.edit(comment: comment)
            .build(baseUrl: baseUrl.appendingPathComponent("\(post.courseId)/posts/\(post.id)"))
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    case .some(422): throw CommentsApiError.validationError
                    default: throw CommentsApiError.other
                }
            }
            .decode(type: CommentsApiResponse.self, decoder: decoder)
            .mapError{ error in
                if let apiError = error as? CommentsApiError {return apiError}
                else {return CommentsApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func delete(post: Post, comment: Comment) -> AnyPublisher<CommentsApiResponse, CommentsApiError> {
        let request = WebCommentsRequest.delete(comment: comment)
            .build(baseUrl: baseUrl.appendingPathComponent("\(post.courseId)/posts/\(post.id)"))
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    default: throw CommentsApiError.other
                }
            }
            .decode(type: CommentsApiResponse.self, decoder: decoder)
            .mapError{ error in
                if let apiError = error as? CommentsApiError {return apiError}
                else {return CommentsApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum WebCommentsRequest {
    case load
    case add(content: String)
    case edit(comment: Comment)
    case delete(comment: Comment)
}

extension WebCommentsRequest: WebRequest {
    var path: String {
        switch self {
            case .load, .add: return "comments"
            case .edit(let comment), .delete(let comment): return "comments/\(comment.id)"
        }
    }
    
    var method: String {
        switch self {
            case .load: return "GET"
            case .add: return "POST"
            case .edit: return "PUT"
            case .delete: return "DELETE"
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    func body() -> Data? {
        switch self {
            case .load, .delete:
                return nil
            case .add(let content):
                return try? JSONEncoder().encode(["content": content])
            case .edit(let comment):
                return try? JSONEncoder().encode(["content": comment.content])
        }
    }
}
