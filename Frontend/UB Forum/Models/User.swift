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

extension User: Codable {
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        guard let imageData = profileImage.jpegData(compressionQuality: 1.0)?.base64EncodedString() else {
            throw EncodingError.invalidValue(Any.self, EncodingError.Context(codingPath: [CodingKeys.profileImage], debugDescription: "Could not encode profileImage to data"))
        }
        try container.encode("data:image/jpeg;base64,\(imageData)", forKey: .profileImage)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
