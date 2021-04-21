import Foundation
import Combine

class AuthInteractor {
    let api: AuthApi
    var state: AppState
    var cancelBag = Set<AnyCancellable>()

    init(api: AuthApi, state: AppState) {
        self.api = api
        self.state = state
    }

    public func logIn(email: String, password: String) {
        api.logIn(email: email, password: password)
            .sink {status in
                switch status {
                    case .failure(let error):
                        self.state.authLoginError = error
                    default: break
                }
            } receiveValue: {res in
                self.state.authToken = res.token
                self.state.authUser = res.user
            }
            .store(in: &cancelBag)
    }
    
    public func logOut() {
        api.logOut()
            .sink {_ in
                self.state.authToken = nil
                self.state.authUser = nil
            } receiveValue: { _ in}
            .store(in: &cancelBag)
    }
}
