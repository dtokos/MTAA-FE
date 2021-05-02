import Foundation

struct AppFactory {
    func makeState() -> AppState {
        return AppState()
    }
    
    func makeInteractors(state: AppState) -> Interactors {
        let auth = AuthInteractor(api: WebAuthApi(), state: state)
        let users = UsersInteractor(api: WebUsersApi(), state: state)
        let courses = CoursesInteractor(api: WebCoursesApi(), state: state)
        let categories = CategoriesInteractor(api: WebCategoriesApi(), state: state)
        let posts = PostsInteractor(api: WebPostsApi(), state: state)
        let comments = CommentsInteractor(api: WebCommentsApi(), state: state)
        
        return Interactors(
            auth: auth,
            users: users,
            courses: courses,
            categories: categories,
            posts: posts,
            comments: comments
        )
    }
    
    func makePersistence() -> Persistence {
        return JSONPersistence(encoder: makeJSONEncoder(), decoder: makeJSONDecoder())
    }
    
    private func makeJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    private func makeJSONDecoder() ->JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
