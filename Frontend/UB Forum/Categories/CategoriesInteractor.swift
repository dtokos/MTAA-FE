import Foundation
import Combine

class CategoriesInteractor {
    let api: CategoriesApi
    var state: AppState
    var cancelBag = Set<AnyCancellable>()

    init(api: CategoriesApi, state: AppState) {
        self.api = api
        self.state = state
    }

    public func load() {
        api.load()
            .sink{_ in} receiveValue: {res in
                self.state.merge(categories: res.categories)
            }
            .store(in: &cancelBag)
    }
}
