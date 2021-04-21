import Foundation
import Combine

class CommentsInteractor {
    let api: CommentsApi
    var state: AppState
    var cancelBag = Set<AnyCancellable>()

    init(api: CommentsApi, state: AppState) {
        self.api = api
        self.state = state
    }

    public func load(post: Post) {
        api.load(post: post)
            .sink{_ in} receiveValue: {res in
                self.state.merge(users: res.users)
                self.state.merge(comments: res.comments)
            }
            .store(in: &cancelBag)
    }
    
    public func add(post: Post, content: String, callback: @escaping () -> Void) {
        api.add(post: post, content: content)
            .sink(receiveCompletion: {status in
                if case .failure(let error) = status {self.state.commentsAddError = error}
            }, receiveValue: {res in
                self.state.merge(users: res.users)
                self.state.merge(comments: res.comments)
                callback()
            })
            .store(in: &cancelBag)
    }
    
    public func edit(post: Post, comment: Comment, callback: @escaping () -> Void) {
        api.edit(post: post, comment: comment)
            .sink(receiveCompletion: {status in
                if case .failure(let error) = status {self.state.commentsEditError = error}
            }, receiveValue: {res in
                self.state.merge(users: res.users)
                self.state.merge(comments: res.comments)
                callback()
            })
            .store(in: &cancelBag)
    }
    
    public func delete(post: Post, comment: Comment) {
        api.delete(post: post, comment: comment)
            .sink(receiveCompletion: {status in
                if case .failure(let error) = status {self.state.commentsDeleteError = error}
            }, receiveValue: {res in
                self.state.merge(users: res.users)
                self.state.delete(comments: res.comments)
            })
            .store(in: &cancelBag)
    }
}
