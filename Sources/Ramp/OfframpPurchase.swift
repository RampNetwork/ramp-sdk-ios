import Foundation

public struct OfframpPurchase: Decodable & Encodable { // Encodable conformance is used in Flutter
    public let id: String
    public let createdAt: String
    public let crypto: Crypto
    public let fiat: Fiat
    
    public struct Crypto: Decodable & Encodable { // Encodable conformance is used in Flutter
        public let amount: String
        public let assetInfo: AssetInfo
        
        public struct AssetInfo: Decodable & Encodable { // Encodable conformance is used in Flutter
            public let address: String?
            public let symbol: String
            public let chain: String
            public let type: String
            public let name: String
            public let decimals: Int
        }
    }
    
    public struct Fiat: Decodable & Encodable { // Encodable conformance is used in Flutter
        public let amount: Double
        public let currencySymbol: String
    }
}
