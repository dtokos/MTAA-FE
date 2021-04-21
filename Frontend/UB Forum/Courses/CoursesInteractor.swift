import Foundation
import Combine

class CoursesInteractor {
    let api: CoursesApi
    var state: AppState
    var cancelBag = Set<AnyCancellable>()

    init(api: CoursesApi, state: AppState) {
        self.api = api
        self.state = state
    }

    public func load() {
        api.load()
            .sink{_ in} receiveValue: {res in
                self.state.merge(courses: res.courses)
            }
            .store(in: &cancelBag)
    }
}
