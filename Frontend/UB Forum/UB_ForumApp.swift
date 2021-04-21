import SwiftUI

@main
struct UB_ForumApp: App {
    @ObservedObject var state: AppState
    @ObservedObject var interactors: Interactors
    
    init() {
        let factory = AppFactory()
        let state = factory.makeState()
        self.state = state
        self.interactors = factory.makeInteractors(state: state)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(state)
                .environmentObject(interactors)
        }
    }
}
