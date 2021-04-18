import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject private var vm = AuthVM()
    
    var body: some View {
        if !vm.isLoggedIn {
            LoginView(authVM: vm)
        } else {
            CoursesView(authVM: vm)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

class AuthVM: ObservableObject {
    //private let api: AuthApi = MemoryAuthApi()
    private let api: AuthApi = WebAuthApi()
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var token: String? = nil
    @Published var user: User? = nil
    @Published var error: AuthApiError? = nil
    @Published var showError = false
    var isLoggedIn: Bool {return token != nil && user != nil}
    
    public func logIn(email: String, password: String) {
        error = nil
        
        api.logIn(email: email, password: password)
            .sink { status in
                switch status {
                    case .failure(let error):
                        self.error = error
                        self.showError = true
                    default: break
                }
            } receiveValue: { res in
                self.token = res.token
                self.user = res.user
            }.store(in: &cancelBag)
    }
    
    public func logout() {
        api.logOut()
            .sink {_ in
                self.token = nil
                self.user = nil
            } receiveValue: { _ in}
            .store(in: &cancelBag)
    }
}
