import Foundation

protocol WebRequest {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func body() -> Data?
}

struct WebRequestShared {
    static var headers = [String: String]()
}

extension WebRequest {
    func build(baseUrl: URL) -> URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = WebRequestShared.headers
            .merging(headers ?? [String:String]()) { (_, new) in new }
        request.httpBody = body()
        return request
    }
}

