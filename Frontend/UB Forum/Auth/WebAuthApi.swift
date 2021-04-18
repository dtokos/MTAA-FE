import Foundation
import Combine

struct WebAuthApi: AuthApi {
    private let baseUrl = URL(string: "http://mtaa.test:8888/api/auth")!
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func logIn(email: String, password: String) -> AnyPublisher<AuthApiResponse, AuthApiError> {
        let request = WebAuthRequest.login(email: email, password: password).build(baseUrl: baseUrl)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ (data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    case .some(401): throw AuthApiError.wrongCredentials
                    case .some(422): throw AuthApiError.validationError
                    default: throw AuthApiError.other
                }
            })
            .decode(type: AuthApiResponse.self, decoder: decoder)
            .mapError({ error in
                if let apiError = error as? AuthApiError {return apiError}
                else {return AuthApiError.other}
            })
            .handleEvents(receiveOutput: { res in
                WebRequestShared.headers["Authorization"] = "Bearer \(res.token)"
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func logOut() -> AnyPublisher<Void, AuthApiError> {
        let request = WebAuthRequest.logout.build(baseUrl: baseUrl)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (_, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200), .some(204): return Void()
                    default: throw AuthApiError.other
                }
            }
            .mapError({ error in
                if let apiError = error as? AuthApiError {return apiError}
                else {return AuthApiError.other}
            })
            .handleEvents(receiveOutput: { _ in
                WebRequestShared.headers.removeValue(forKey: "Authorization")
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum WebAuthRequest {
    case login(email: String, password: String)
    case logout
}

extension WebAuthRequest: WebRequest {
    var path: String {
        switch self {
            case .login: return "login"
            case .logout: return "logout"
        }
    }
    
    var method: String {
        return "POST"
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    func body() -> Data? {
        switch self {
            case .login(let email, let password): return try? JSONEncoder().encode(["email": email, "password": password])
            case .logout: return nil
        }
    }
}
