import Combine

protocol CoursesApi {
    func load() -> AnyPublisher<CoursesApiResponse, CoursesApiError>
}

struct CoursesApiResponse: Decodable {
    let courses: [Int: Course]
}

enum CoursesApiError: Error {
    case other
}
