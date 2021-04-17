//import Foundation
//import Combine
//
//class AuthInteractor {
//    let api: AuthApi
//    let state: CurrentValueSubject<AppState, Never>
//    var cancelBag = Set<AnyCancellable>()
//
//    init(api: AuthApi, state: CurrentValueSubject<AppState, Never>) {
//        self.api = api
//        self.state = state
//    }
//
//    public func logIn(email: String, password: String) {
//        api.logIn(email: email, password: password)
//            .sink { error in
//                print(error)
//            } receiveValue: { res in
//                self.state[\.auth].token = res.token
//                self.state[\.auth].user = res.user
//            }.store(in: &cancelBag)
//
//    }
//}
