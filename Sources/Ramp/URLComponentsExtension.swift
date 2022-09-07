import Foundation

extension URLComponents {
    mutating func appendQueryItem<V: RawRepresentable>(name: String, value: V?) where V.RawValue == String  {
        guard let value = value else { return }
        appendQueryItem(name: name, value: value.rawValue)
    }
    
    mutating func appendQueryItem(name: String, value: Int?) {
        guard let value = value else { return }
        appendQueryItem(name: name, value: String(value))
    }
    
    mutating func appendQueryItem(name: String, value: String?) {
        guard let value = value, !value.isEmpty else { return }
        let queryItem = URLQueryItem(name: name, value: value)
        if queryItems == nil { queryItems = [queryItem] }
        else { queryItems!.append(queryItem) }
    }
}
