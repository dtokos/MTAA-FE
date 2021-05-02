import Foundation

class JSONPersistence: Persistence {
    private struct StoredData: Codable {
        var authToken: String?
        var authUser: User?
        
        var users = [Int: User]()
        var courses = [Int: Course]()
        var categories = [Int: Category]()
        var posts = [Int: Post]()
        var comments = [Int: Comment]()
    }
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(encoder: JSONEncoder, decoder: JSONDecoder) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func load(state: AppState) {
        do {
            let storedUrl = try fileUrl()
            let data = try Data(contentsOf: storedUrl)
            let storedData = try decoder.decode(StoredData.self, from: data)
            
            state.authToken = storedData.authToken
            state.authUser = storedData.authUser
            state.merge(categories: storedData.categories)
            state.merge(users: storedData.users)
            state.merge(courses: storedData.courses)
            state.merge(posts: storedData.posts)
            state.merge(comments: storedData.comments)
        } catch {
            print("Unable to load state: \(error)")
        }
    }
    
    func save(state: AppState) {
        do {
            var storedData = StoredData()
            storedData.authToken = state.authToken
            storedData.authUser = state.authUser
            storedData.users = state.users
            storedData.courses = state.courses
            storedData.categories = state.categories
            storedData.posts = state.posts
            storedData.comments = state.comments
            
            let storedUrl = try fileUrl()
            let data = try encoder.encode(storedData)
            try data.write(to: storedUrl)
        } catch {
            print("Unable to save state: \(error)")
        }
    }
    
    private func fileUrl() throws -> URL {
        let documents = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return URL(fileURLWithPath: "data", relativeTo: documents)
            .appendingPathExtension("json")
    }
}
