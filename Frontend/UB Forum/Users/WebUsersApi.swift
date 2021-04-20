import Foundation
import Combine
import UIKit

struct WebUsersApi: UsersApi {
    private let baseUrl = URL(string: "http://mtaa.test:8888/api/users")!
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func edit(user: User, password: String?, profileImage: UIImage?) -> AnyPublisher<UsersApiResponse, UsersApiError> {
        let request = WebUsersRequest.edit(user: user, password: password, profileImage: profileImage).build(baseUrl: baseUrl)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{(data, res) in
                switch (res as? HTTPURLResponse)?.statusCode {
                    case .some(200): return data
                    case .some(422): throw UsersApiError.validationError
                    default: throw AuthApiError.other
                }
            }
            .decode(type: UsersApiResponse.self, decoder: decoder)
            .mapError{ error in
                if let apiError = error as? UsersApiError {return apiError}
                else {return UsersApiError.other}
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum WebUsersRequest {
    case edit(user: User, password: String?, profileImage: UIImage?)
}

extension WebUsersRequest: WebRequest {
    var path: String {
        switch self {
            case .edit(let user, _, _): return "\(user.id)"
        }
    }
    
    var method: String {
        return "PUT"
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    func body() -> Data? {
        switch self {
            case .edit(let user, let pass, let img):
                return try? JSONEncoder().encode([
                    "name": user.name,
                    "email": user.email,
                    "password": pass,
                    "profile_image": self.encodeImage(image: img),
                ])
        }
    }
    
    private func encodeImage(image: UIImage?) -> String? {
        guard let image = image else {return nil}
        return image.jpegData(compressionQuality: 1.0)?.base64EncodedString()
    }
}
