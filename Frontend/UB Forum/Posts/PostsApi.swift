import Combine

protocol PostsApi {
    func load(course: Course) -> AnyPublisher<PostsApiResponse, PostsApiError>
    func add(course: Course, title: String, category: Category, content: String) -> AnyPublisher<PostsApiResponse, PostsApiError>
    func edit(post: Post) -> AnyPublisher<PostsApiResponse, PostsApiError>
    func delete(post: Post) -> AnyPublisher<PostsApiResponse, PostsApiError>
}

struct PostsApiResponse: Decodable {
    let posts: [Int: Post]
    let users: [Int: User]
    let categories: [Int: Category]
}

enum PostsApiError: Error {
    case validationError
    case other
}
