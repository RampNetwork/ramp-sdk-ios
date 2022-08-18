import Foundation

public struct OfframpPurchase: Codable {
    public let id: String
    public let createdAt: String
    public let crypto: Crypto
    public let fiat: Fiat
    
    public struct Crypto: Codable {
        public let amount: String
        public let assetInfo: AssetInfo
        
        public struct AssetInfo: Codable {
            public let address: String?
            public let symbol: String
            public let chain: String
            public let type: String
            public let name: String
            public let decimals: Int
        }
    }
    
    public struct Fiat: Codable {
        public let amount: Double
        public let currencySymbol: String
    }
}
