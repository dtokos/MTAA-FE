import Combine

protocol CategoriesApi {
    func load() -> AnyPublisher<CategoriesApiResponse, CategoriesApiError>
}

struct CategoriesApiResponse: Decodable {
    let categories: [Int: Category]
}

enum CategoriesApiError: Error {
    case other
}
