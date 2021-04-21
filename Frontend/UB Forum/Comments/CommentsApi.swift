import Combine

protocol CommentsApi {
    func load(post: Post) -> AnyPublisher<CommentsApiResponse, CommentsApiError>
    func add(post: Post, content: String) -> AnyPublisher<CommentsApiResponse, CommentsApiError>
    func edit(post: Post, comment: Comment) -> AnyPublisher<CommentsApiResponse, CommentsApiError>
    func delete(post: Post, comment: Comment) -> AnyPublisher<CommentsApiResponse, CommentsApiError>
}

struct CommentsApiResponse: Decodable {
    let comments: [Int: Comment]
    let users: [Int: User]
}

enum CommentsApiError: Error {
    case validationError
    case other
}

extension CommentsApiError: Identifiable {
    var id: Int { hashValue }
}
