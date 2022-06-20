import Foundation

public struct OffRampPurchase: Decodable {
    public let id: String
    public let createdAt: String
    public let crypto: Crypto
    public let fiat: Fiat
    
    public struct Crypto: Decodable {
        public let amount: String
        public let assetInfo: AssetInfo
        
        public struct AssetInfo: Decodable {
            public let address: String?
            public let symbol: String
            public let chain: String
            public let type: String
            public let name: String
            public let decimals: Int
        }
    }
    
    public struct Fiat: Decodable {
        public let amount: Double
        public let currencySymbol: String
    }
}
