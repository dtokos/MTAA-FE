import Foundation

class Interactors: ObservableObject {
    var auth: AuthInteractor
    var users: UsersInteractor
    var courses: CoursesInteractor
    var categories: CategoriesInteractor
    var posts: PostsInteractor
    var comments: CommentsInteractor
    
    init(auth: AuthInteractor,
         users: UsersInteractor,
         courses: CoursesInteractor,
         categories: CategoriesInteractor,
         posts: PostsInteractor,
         comments: CommentsInteractor
    ) {
        self.auth = auth
        self.users = users
        self.courses = courses
        self.categories = categories
        self.posts = posts
        self.comments = comments
    }
}
