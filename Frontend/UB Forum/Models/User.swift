import Foundation
import UIKit

struct User: Equatable {
    var id: Int
    var name: String
    var email: String
    var profileImage: UIImage
    var createdAt: Date
    var updatedAt: Date
    
    #if DEBUG
        static let example = User(id: 1, name: "Eugen Ártvy", email: "", profileImage: UIImage(named: "userPlaceholder")!, createdAt: Date(), updatedAt: Date())
    #endif
}

extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case profileImage = "profile_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        email = try values.decode(String.self, forKey: .email)
        let imageData = try Data(contentsOf: values.decode(URL.self, forKey: .profileImage))
        profileImage = UIImage(data: imageData) ?? UIImage(named: "userPlaceholder")!
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        updatedAt = try values.decode(Date.self, forKey: .updatedAt)
    }
}
