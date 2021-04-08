import SwiftUI

struct MainView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        if !isLoggedIn {
            LoginView(isLoggedIn: $isLoggedIn)
        } else {
            CoursesView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
