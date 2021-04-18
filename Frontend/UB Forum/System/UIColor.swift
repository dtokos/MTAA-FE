import UIKit

extension UIColor {
    static func system(string: String) -> UIColor {
        switch string {
            case "blue": return .systemBlue
            case "green": return .systemGreen
            case "indigo": return .systemIndigo
            case "orange": return .systemOrange
            case "pink": return .systemPink
            case "purple": return .systemPurple
            case "red": return .systemRed
            case "teal": return .systemTeal
            case "yellow": return .systemYellow
            default: return .systemBlue
        }
    }
}
