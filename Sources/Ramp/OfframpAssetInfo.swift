import Foundation

public struct OfframpAssetInfo: Codable {
    public let address: String?
    public let chain: String
    public let decimals: Int
    public let name: String
    public let symbol: String
    public let type: String
}
