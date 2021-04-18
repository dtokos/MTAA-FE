import Foundation
import UIKit

struct Course: Identifiable {
    var id: Int
    var title: String
    var color: UIColor
    var createdAt: Date
    var updatedAt: Date
    
    #if DEBUG
        static let example = Course(id: 1, title: "OOP", color: .systemGreen, createdAt: Date(), updatedAt: Date())
    #endif
}

extension Course: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case color = "color"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        color = try UIColor.system(string: values.decode(String.self, forKey: .color))
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        updatedAt = try values.decode(Date.self, forKey: .updatedAt)
    }
}
