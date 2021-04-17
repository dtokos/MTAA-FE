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
