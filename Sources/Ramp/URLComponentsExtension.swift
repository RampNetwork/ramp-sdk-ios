import Foundation

extension URLComponents {
    mutating func appendQueryItem(name: String, value: String?) {
        guard let value = value else { return }
        let queryItem = URLQueryItem(name: name, value: value)
        if queryItems == nil { queryItems = [queryItem] }
        else { queryItems!.append(queryItem) }
    }
}
