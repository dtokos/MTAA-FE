import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject private var state: AppState
    
    var body: some View {
        if !state.authLoggedIn {
            loginView
        } else {
            coursesView
        }
    }
    
    var loginView: some View {
        LoginView()
    }
    
    var coursesView: some View {
        CoursesView()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
