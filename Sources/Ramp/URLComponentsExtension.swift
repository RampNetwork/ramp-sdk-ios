import Foundation

extension URLComponents {
    mutating func appendQueryItem(name: String, value: String?) {
        guard let value, !value.isEmpty else {
            return
        }
        let queryItem = URLQueryItem(name: name, value: value)
        if queryItems == nil {
            queryItems = [queryItem]
        } else {
            queryItems!.append(queryItem)
        }
    }
    
    mutating func appendQueryItem(name: String, value: Bool?) {
        guard let value else {
            return
        }
        appendQueryItem(name: name, value: value ? "true" : "false")
    }
}
