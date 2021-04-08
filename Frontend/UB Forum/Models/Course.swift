import Foundation
import UIKit

struct Course {
    var id: Int
    var title: String
    var color: UIColor
    var createdAt: Date
    var updatedAt: Date
    
    #if DEBUG
        static let example = Course(id: 1, title: "OOP", color: .systemGreen, createdAt: Date(), updatedAt: Date())
    #endif
}
