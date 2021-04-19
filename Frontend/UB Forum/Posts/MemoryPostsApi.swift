import Foundation
import Combine
import UIKit

struct MemoryPostsApi: PostsApi {
    private let users = [
        1: User(id: 1, name: "Eugen Ártvy", email: "", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date()),
        2: User(id: 2, name: "Briana Leffler", email: "", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date()),
        3: User(id: 3, name: "Simeon Schuster", email: "", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date()),
    ]
    private static var posts = [
        1: Post(id: 1, userId: 1, courseId: 1, categoryId: 1, title: "Lorem ipsum", content: "Lorem ipsum dolor sit amet...", createdAt: Date(), updatedAt: Date()),
        2: Post(id: 2, userId: 2, courseId: 1, categoryId: 2, title: "In semper", content: "In semper ultricies risus...", createdAt: Date(), updatedAt: Date()),
        3: Post(id: 3, userId: 3, courseId: 1, categoryId: 3, title: "Curabitur suscipit", content: "Curabitur suscipit dui id mi...", createdAt: Date(), updatedAt: Date()),
        4: Post(id: 4, userId: 1, courseId: 1, categoryId: 4, title: "Proin euismod", content: "Proin euismod ex quis egestas...", createdAt: Date(), updatedAt: Date()),
        5: Post(id: 5, userId: 2, courseId: 1, categoryId: 1, title: "Morbi porta", content: "Morbi porta dapibus mauris...", createdAt: Date(), updatedAt: Date()),
        6: Post(id: 6, userId: 3, courseId: 1, categoryId: 2, title: "Et at id", content: "Sit dolorem ut asperiores assumenda...", createdAt: Date(), updatedAt: Date()),
        7: Post(id: 7, userId: 1, courseId: 1, categoryId: 3, title: "Natus voluptatum vero", content: "Eveniet saepe aspernatur omnis...", createdAt: Date(), updatedAt: Date()),
    ]
    private let categories = [
        1: Category(id: 1, title: "Cvičenia", color: .systemGreen, createdAt: Date(), updatedAt: Date()),
        2: Category(id: 2, title: "Zadania", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        3: Category(id: 3, title: "Skúšky", color: .systemYellow, createdAt: Date(), updatedAt: Date()),
        4: Category(id: 4, title: "Iné", color: .systemTeal, createdAt: Date(), updatedAt: Date()),
    ]
    
    private static var nextId = 5
    
    func load(course: Course) -> AnyPublisher<PostsApiResponse, PostsApiError> {
        return Just(PostsApiResponse(posts: MemoryPostsApi.posts, users: users, categories: categories))
            .setFailureType(to: PostsApiError.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(course: Course, title: String, category: Category, content: String) -> AnyPublisher<PostsApiResponse, PostsApiError> {
        MemoryPostsApi.nextId += 1
        let user = users[1]!
        let post = Post(
            id: MemoryPostsApi.nextId,
            userId: user.id,
            courseId: course.id,
            categoryId: category.id,
            title: title,
            content: content,
            createdAt: Date(),
            updatedAt: Date()
        )
        MemoryPostsApi.posts[post.id] = post
        
        return Just(PostsApiResponse(posts: [post.id: post], users: [user.id:user], categories: [category.id:category]))
            .setFailureType(to: PostsApiError.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
