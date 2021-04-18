import Combine

protocol PostsApi {
    func load(course: Course) -> AnyPublisher<PostsApiResponse, PostsApiError>
}

struct PostsApiResponse: Decodable {
    let posts: [Int: Course]
    let users: [Int: User]
    let categories: [Int: Category]
}

enum PostsApiError: Error {
    case other
}
