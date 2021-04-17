import Combine

protocol AuthApi {
    func logIn(email: String, password: String) -> AnyPublisher<AuthApiResponse, AuthApiError>
    func logOut() -> AnyPublisher<Void, AuthApiError>
}

struct AuthApiResponse {
    let token: String
    let user: User
}

enum AuthApiError: Error {
    case wrongCredentials
    case other(Error)
}
