import Foundation

struct Post: Identifiable {
    var id: Int
    var userId: Int
    var courseId: Int
    var categoryId: Int
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    
    var createdAgo: String {
        return Post.dateFormatter.localizedString(for: createdAt, relativeTo: Date())
    }
    
    static let dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale.init(identifier: "sk")
        formatter.unitsStyle = .full
        return formatter
    }()
    
    #if DEBUG
        static let example = Post(id: 1, userId: 1, courseId: 1, categoryId: 0, title: "Lorem ipsum", content: "Lorem ipsum dolor sit amet...", createdAt: Date(), updatedAt: Date())
    #endif
}

extension Post: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case courseId = "course_id"
        case categoryId = "category_id"
        case title = "title"
        case content = "content"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        userId = try values.decode(Int.self, forKey: .userId)
        courseId = try values.decode(Int.self, forKey: .courseId)
        categoryId = try values.decode(Int.self, forKey: .categoryId)
        title = try values.decode(String.self, forKey: .title)
        content = try values.decode(String.self, forKey: .content)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        updatedAt = try values.decode(Date.self, forKey: .updatedAt)
    }
}
