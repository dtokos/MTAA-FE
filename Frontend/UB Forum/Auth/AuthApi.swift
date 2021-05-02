import Foundation
import Combine

protocol AuthApi {
    func logIn(email: String, password: String) -> AnyPublisher<AuthApiResponse, AuthApiError>
    func logOut() -> AnyPublisher<Void, AuthApiError>
    func setToken(token: String?)
}

struct AuthApiResponse: Decodable {
    let token: String
    let user: User
}

enum AuthApiError: Error {
    case validationError
    case wrongCredentials
    case other
}

extension AuthApiError: Identifiable {
    var id: Int { hashValue }
}
