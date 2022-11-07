import Foundation

public struct OfframpSale: Codable {
    public let createdAt: String
    public let crypto: Crypto
    public let fiat: Fiat
    public let id: UUID
    
    public struct Crypto: Codable {
        public let amount: String
        public let assetInfo: OfframpAssetInfo
    }
    
    public struct Fiat: Codable {
        public let amount: Double
        public let currencySymbol: String
    }
}
