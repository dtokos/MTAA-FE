import Foundation

struct Comment: Identifiable {
    var id: Int
    var userId: Int
    var postId: Int
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
        static let example = Comment(id: 1, userId: 1, postId: 1, content: "Lorem ipsum dolor sit amet...", createdAt: Date(), updatedAt: Date())
    #endif
}

extension Comment: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case postId = "post_id"
        case content = "content"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        userId = try values.decode(Int.self, forKey: .userId)
        postId = try values.decode(Int.self, forKey: .postId)
        content = try values.decode(String.self, forKey: .content)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        updatedAt = try values.decode(Date.self, forKey: .updatedAt)
    }
}


