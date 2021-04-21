import Foundation
import Combine
import UIKit

class UsersInteractor {
    let api: UsersApi
    var state: AppState
    var cancelBag = Set<AnyCancellable>()

    init(api: UsersApi, state: AppState) {
        self.api = api
        self.state = state
    }

    public func edit(user: User, password: String?, profileImage: UIImage?, callback: @escaping () -> Void) {
        api.edit(user: user, password: password, profileImage: profileImage)
            .sink(receiveCompletion: {status in
                if case .failure(let error) = status {self.state.usersEditError = error}
            }, receiveValue: {res in
                self.state.merge(users: res.users)
                callback()
            })
            .store(in: &cancelBag)
    }
}
