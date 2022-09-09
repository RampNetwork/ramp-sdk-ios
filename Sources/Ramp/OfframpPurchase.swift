import Foundation

public struct OfframpPurchase: Codable {
    public let createdAt: String
    public let crypto: Crypto
    public let fiat: Fiat
    public let id: UUID
    
    public struct Crypto: Codable {
        public let amount: String
        public let assetInfo: AssetInfo
        
        public struct AssetInfo: Codable {
            public let address: String?
            public let chain: String
            public let decimals: Int
            public let name: String
            public let symbol: String
            public let type: String
        }
    }
    
    public struct Fiat: Codable {
        public let amount: Double
        public let currencySymbol: String
    }
}
