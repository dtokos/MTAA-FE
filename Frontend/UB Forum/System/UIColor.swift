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
    
    func systemToString() -> String {
        switch self {
            case .systemBlue: return "blue"
            case .systemGreen: return "green"
            case .systemIndigo: return "indigo"
            case .systemOrange: return "orange"
            case .systemPink: return "pink"
            case .systemPurple: return "purple"
            case .systemRed: return "red"
            case .systemTeal: return "teal"
            case .systemYellow: return "yellow"
            default: return "blue"
        }
    }
}
