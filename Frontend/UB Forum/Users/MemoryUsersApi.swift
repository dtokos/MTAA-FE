import Foundation
import Combine
import UIKit

struct MemoryUsersApi: UsersApi {
    func edit(user: User, password: String?, profileImage: UIImage?) -> AnyPublisher<UsersApiResponse, UsersApiError> {
        var userCopy = user
        if let profileImage = profileImage {userCopy.profileImage = profileImage}
        
        return Just(UsersApiResponse(users: [userCopy.id: userCopy]))
            .setFailureType(to: UsersApiError.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
