import Foundation

struct AppFactory {
    func makeState() -> AppState {
        return AppState()
    }
    
    func makeInteractors(state: AppState) -> Interactors {
        let decoder = makeJSONDecoder()
        
        let auth = AuthInteractor(api: WebAuthApi(decoder: decoder), state: state)
        let users = UsersInteractor(api: WebUsersApi(decoder: decoder), state: state)
        let courses = CoursesInteractor(api: WebCoursesApi(decoder: decoder), state: state)
        let categories = CategoriesInteractor(api: WebCategoriesApi(decoder: decoder), state: state)
        let posts = PostsInteractor(api: WebPostsApi(decoder: decoder), state: state)
        let comments = CommentsInteractor(api: WebCommentsApi(decoder: decoder), state: state)
        
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
