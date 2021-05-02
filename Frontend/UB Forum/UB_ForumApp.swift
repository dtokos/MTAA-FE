import SwiftUI

@main
struct UB_ForumApp: App {
    @ObservedObject var state: AppState
    @ObservedObject var interactors: Interactors
    private var persistence: Persistence
    
    init() {
        let factory = AppFactory()
        let state = factory.makeState()
        self.persistence = factory.makePersistence()
        self.persistence.load(state: state)
        self.state = state
        self.interactors = factory.makeInteractors(state: state)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { _ in
                    self.persistence.save(state: self.state)
                })
                .environmentObject(state)
                .environmentObject(interactors)
        }
    }
}
