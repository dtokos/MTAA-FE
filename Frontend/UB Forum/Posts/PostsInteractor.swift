import Foundation
import Combine

class PostsInteractor {
    let api: PostsApi
    var state: AppState
    var cancelBag = Set<AnyCancellable>()

    init(api: PostsApi, state: AppState) {
        self.api = api
        self.state = state
    }

    public func load(course: Course) {
        api.load(course: course)
            .sink{_ in} receiveValue: {res in
                self.state.merge(users: res.users)
                self.state.merge(categories: res.categories)
                self.state.merge(posts: res.posts)
            }
            .store(in: &cancelBag)
    }
    
    public func add(course: Course, title: String, category: Category, content: String, callback: @escaping () -> Void) {
        api.add(course: course, title: title, category: category, content: content)
            .sink(receiveCompletion: {status in
                if case .failure(let error) = status {self.state.postsAddError = error}
            }, receiveValue: {res in
                self.state.merge(users: res.users)
                self.state.merge(categories: res.categories)
                self.state.merge(posts: res.posts)
                callback()
            })
            .store(in: &cancelBag)
    }
    
    public func edit(post: Post, callback: @escaping () -> Void) {
        api.edit(post: post)
            .sink(receiveCompletion: {status in
                if case .failure(let error) = status {self.state.postsEditError = error}
            }, receiveValue: {res in
                self.state.merge(users: res.users)
                self.state.merge(categories: res.categories)
                self.state.merge(posts: res.posts)
                callback()
            })
            .store(in: &cancelBag)
    }
    
    public func delete(post: Post, callback: @escaping () -> Void) {
        api.delete(post: post)
            .sink(receiveCompletion: {status in
                if case .failure(let error) = status {self.state.postsDeleteError = error}
            }, receiveValue: {res in
                self.state.merge(users: res.users)
                self.state.merge(categories: res.categories)
                self.state.delete(posts: res.posts)
                callback()
            })
            .store(in: &cancelBag)
    }
}
