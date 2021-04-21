import Combine
import UIKit

protocol UsersApi {
    func edit(user: User, password: String?, profileImage: UIImage?) -> AnyPublisher<UsersApiResponse, UsersApiError>
}

struct UsersApiResponse: Decodable {
    let users: [Int: User]
}

enum UsersApiError: Error {
    case validationError
    case other
}

extension UsersApiError: Identifiable {
    var id: Int { hashValue }
}
