import Foundation
import Combine
import UIKit

struct MemoryCategoriesApi: CategoriesApi {
    private let categories = [
        1: Category(id: 1, title: "Cvičenia", color: .systemGreen, createdAt: Date(), updatedAt: Date()),
        2: Category(id: 2, title: "Zadania", color: .systemRed, createdAt: Date(), updatedAt: Date()),
        3: Category(id: 3, title: "Skúšky", color: .systemYellow, createdAt: Date(), updatedAt: Date()),
        4: Category(id: 4, title: "Iné", color: .systemTeal, createdAt: Date(), updatedAt: Date()),
    ]
    
    func load() -> AnyPublisher<CategoriesApiResponse, CategoriesApiError> {
        return Just(CategoriesApiResponse(categories: categories))
            .setFailureType(to: CategoriesApiError.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
