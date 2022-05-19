import Foundation

public struct OfframpRequest: Decodable {
    public let param1: String
    public let param2: String
}

public struct OfframpResponse: Encodable {
    let asset: String
    let address: String
    
    public init(asset: String, address: String) {
        self.asset = asset
        self.address = address
    }
}
