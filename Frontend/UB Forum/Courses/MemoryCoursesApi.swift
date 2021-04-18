import Foundation
import Combine
import UIKit

struct MemoryCoursesApi: CoursesApi {
    private let courses = [
        1 : Course(id: 1, title: "OOP", color: .systemGreen, createdAt: Date(), updatedAt: Date()),
        2 : Course(id: 2, title: "AJ", color: .systemPink, createdAt: Date(), updatedAt: Date()),
        3 : Course(id: 3, title: "ADM", color: .systemYellow, createdAt: Date(), updatedAt: Date()),
        4 : Course(id: 4, title: "MA", color: .systemPurple, createdAt: Date(), updatedAt: Date()),
        5: Course(id: 5, title: "MIP", color: .systemPurple, createdAt: Date(), updatedAt: Date()),
        6: Course(id: 6, title: "PPI", color: .systemPink, createdAt: Date(), updatedAt: Date()),
        7: Course(id: 7, title: "PRPR", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        8: Course(id: 8, title: "ZOOP", color: .systemOrange, createdAt: Date(), updatedAt: Date()),
        9: Course(id: 9, title: "PAM", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        10: Course(id: 10, title: "FYZ", color: .systemPurple, createdAt: Date(), updatedAt: Date()),
        11: Course(id: 11, title: "TZIV", color: .systemYellow, createdAt: Date(), updatedAt: Date()),
        12: Course(id: 12, title: "ELN", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        13: Course(id: 13, title: "ML1", color: .systemIndigo, createdAt: Date(), updatedAt: Date()),
        14: Course(id: 14, title: "SPRO", color: .systemTeal, createdAt: Date(), updatedAt: Date()),
        15: Course(id: 15, title: "SPAASM", color: .systemPurple, createdAt: Date(), updatedAt: Date()),
        16: Course(id: 16, title: "MSOFT", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        17: Course(id: 17, title: "PARALPR", color: .systemTeal, createdAt: Date(), updatedAt: Date()),
        18: Course(id: 18, title: "APC", color: .systemOrange, createdAt: Date(), updatedAt: Date()),
    ]
    
    func load() -> AnyPublisher<CoursesApiResponse, CoursesApiError> {
        return Just(CoursesApiResponse(courses: courses))
            .setFailureType(to: CoursesApiError.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
