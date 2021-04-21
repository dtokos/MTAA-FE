import Foundation

class AppState: ObservableObject {
    // MARK: - Auth
    @Published var authToken: String? = nil
    @Published var authUser: User? = nil
    @Published var authLoginError: AuthApiError? = nil
    var authLoggedIn: Bool {
        return authToken != nil && authUser != nil
    }
    
    
    
    // MARK: - Users
    @Published var users = [Int:User]()
    @Published var usersEditError: UsersApiError? = nil
    
    func merge(users: [Int:User]) {
        self.users.merge(users) { $0.updatedAt < $1.updatedAt ? $1 : $0 }
        
        if let currentUser = authUser,
           let newUser = users[currentUser.id],
           currentUser.updatedAt < newUser.updatedAt {
            self.authUser = newUser
        }
    }
    
    
    
    // MARK: - Courses
    @Published var courses = [Int:Course]()
    @Published var coursesSelected: Course? = nil
    var coursesByName: [Course] {
        return courses.values.sorted {$0.title < $1.title}
    }
    
    func merge(courses: [Int:Course]) {
        self.courses.merge(courses) { $0.updatedAt < $1.updatedAt ? $1 : $0 }
    }
    
    
    // MARK: - Categories
    @Published var categories = [Int:Category]()
    var categoriesByName: [Category] {
        return categories.values.sorted {$0.title < $1.title}
    }
    
    func merge(categories: [Int:Category]) {
        self.categories.merge(categories) { $0.updatedAt < $1.updatedAt ? $1 : $0 }
    }
    
    
    
    // MARK: - Posts
    @Published var posts = [Int:Post]()
    @Published var postsSeleted: Post? = nil
    @Published var postsAddError: PostsApiError? = nil
    @Published var postsEditError: PostsApiError? = nil
    @Published var postsDeleteError: PostsApiError? = nil
    var postsByDate: [Post] {
        guard let course = coursesSelected else {return [Post]()}
        return posts.values.filter { $0.courseId == course.id }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func merge(posts: [Int:Post]) {
        self.posts.merge(posts) { $0.updatedAt < $1.updatedAt ? $1 : $0 }
        
        if let editingPost = postsSeleted,
           let newPost = posts[editingPost.id],
           editingPost.updatedAt < newPost.updatedAt {
            self.postsSeleted = newPost
        }
    }
    
    func delete(posts: [Int:Post]) {
        self.posts = self.posts.filter {!posts.keys.contains($0.key)}
    }
    
    
    
    // MARK: - Comments
    @Published var comments = [Int:Comment]()
    @Published var commentsSelected: Comment? = nil
    @Published var commentsAddError: CommentsApiError? = nil
    @Published var commentsEditError: CommentsApiError? = nil
    @Published var commentsDeleteError: CommentsApiError? = nil
    var commentsByDate: [Comment] {
        guard let post = postsSeleted else {return [Comment]()}
        return comments.values.filter { $0.postId == post.id }
            .sorted { $0.createdAt < $1.createdAt }
    }
    
    func merge(comments: [Int:Comment]) {
        self.comments.merge(comments) { $0.updatedAt < $1.updatedAt ? $1 : $0 }
    }
    
    func delete(comments: [Int:Comment]) {
        self.comments = self.comments.filter {!comments.keys.contains($0.key)}
    }
}
