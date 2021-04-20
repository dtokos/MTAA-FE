import Foundation
import Combine
import UIKit

struct MemoryCommentsApi: CommentsApi {
    private let users = [
        1: User(id: 1, name: "Eugen Ártvy", email: "", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date()),
        2: User(id: 2, name: "Briana Leffler", email: "", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date()),
        3: User(id: 3, name: "Simeon Schuster", email: "", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date()),
    ]
    private static var comments = [
        1: Comment(id: 1, userId: 1, postId: 1, content: "Lorem ipsum dolor sit amet...", createdAt: Date(), updatedAt: Date()),
        2: Comment(id: 2, userId: 2, postId: 1, content: "In semper ultricies risus...", createdAt: Date(), updatedAt: Date()),
        3: Comment(id: 3, userId: 3, postId: 1, content: "Curabitur suscipit dui id mi...", createdAt: Date(), updatedAt: Date()),
        4: Comment(id: 4, userId: 1, postId: 1, content: "Proin euismod ex quis egestas...", createdAt: Date(), updatedAt: Date()),
        5: Comment(id: 5, userId: 2, postId: 1, content: "Morbi porta dapibus mauris...", createdAt: Date(), updatedAt: Date()),
        6: Comment(id: 6, userId: 3, postId: 1, content: "Sit dolorem ut asperiores assumenda...", createdAt: Date(), updatedAt: Date()),
        7: Comment(id: 7, userId: 1, postId: 1, content: "Eveniet saepe aspernatur omnis...", createdAt: Date(), updatedAt: Date()),
    ]
    
    private static var nextId = 5
    
    func load(post: Post) -> AnyPublisher<CommentsApiResponse, CommentsApiError> {
        return Just(CommentsApiResponse(comments: MemoryCommentsApi.comments, users: users))
            .setFailureType(to: CommentsApiError.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(post: Post, content: String) -> AnyPublisher<CommentsApiResponse, CommentsApiError> {
        MemoryCommentsApi.nextId += 1
        let user = users[1]!
        let comment = Comment(
            id: MemoryCommentsApi.nextId,
            userId: user.id,
            postId: post.id,
            content: content,
            createdAt: Date(),
            updatedAt: Date()
        )
        MemoryCommentsApi.comments[comment.id] = comment
        
        return Just(CommentsApiResponse(comments: [comment.id: comment], users: [user.id:user]))
            .setFailureType(to: CommentsApiError.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func edit(post: Post, comment: Comment) -> AnyPublisher<CommentsApiResponse, CommentsApiError> {
        if MemoryCommentsApi.comments[comment.id] != nil, let user = users[post.userId] {
            MemoryCommentsApi.comments[comment.id] = comment
            return Just(CommentsApiResponse(comments: [comment.id: comment], users: [user.id: user]))
                .setFailureType(to: CommentsApiError.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: CommentsApiError.other)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
    
    func delete(post: Post, comment: Comment) -> AnyPublisher<CommentsApiResponse, CommentsApiError> {
        if MemoryCommentsApi.comments[comment.id] != nil, let user = users[comment.userId] {
            MemoryCommentsApi.comments.removeValue(forKey: post.id)
            return Just(CommentsApiResponse(comments: [comment.id: comment], users: [user.id: user]))
                .setFailureType(to: CommentsApiError.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: CommentsApiError.other)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}
