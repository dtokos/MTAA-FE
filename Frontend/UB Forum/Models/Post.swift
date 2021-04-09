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
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale.init(identifier: "sk")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: createdAt, relativeTo: Date().advanced(by: 60))
    }
    
    #if DEBUG
        static let example = Post(id: 1, userId: 1, courseId: 1, categoryId: 0, title: "Lorem ipsum", content: "Lorem ipsum dolor sit amet...", createdAt: Date(), updatedAt: Date())
    #endif
}
