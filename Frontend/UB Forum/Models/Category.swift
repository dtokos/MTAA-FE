import Foundation
import UIKit

struct Category: Identifiable, Hashable {
    var id: Int
    var title: String
    var color: UIColor
    var createdAt: Date
    var updatedAt: Date
    
    #if DEBUG
        static let example = Category(id: 0, title: "Prednášky", color: .systemPink, createdAt: Date(), updatedAt: Date())
    #endif
}
