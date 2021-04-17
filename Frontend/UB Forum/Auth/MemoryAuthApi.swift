import Foundation
import Combine
import UIKit

struct MemoryAuthApi: AuthApi {
    private let users = [
        User(id: 1, name: "Eugen Ártvy", email: "eugen.artvy@gmail.com", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date()),
    ]
    
    func logIn(email: String, password: String) -> AnyPublisher<AuthApiResponse, AuthApiError> {
        let user = users.first { $0.email == email }
        
        if let user = user {
            return Just(AuthApiResponse(token: "fakeToken", user: user))
                .setFailureType(to: AuthApiError.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: AuthApiError.wrongCredentials)
                .eraseToAnyPublisher()
        }
    }
    
    func logOut() -> AnyPublisher<Void, AuthApiError> {
        return Just<Void>(())
            .setFailureType(to: AuthApiError.self)
            .eraseToAnyPublisher()
    }
}
