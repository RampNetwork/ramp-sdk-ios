import Foundation

public struct OnrampPurchase: Codable {
    public let appliedFee: Double
    public let asset: AssetInfo
    public let assetExchangeRate: Double
    public let baseRampFee: Double
    public let createdAt: String
    public let cryptoAmount: String
    public let endTime: String?
    public let escrowAddress: String?
    public let escrowDetailsHash: String?
    public let fiatCurrency: String
    public let fiatValue: Double
    public let finalTxHash: String?
    public let id: String
    public let networkFee: Double
    public let paymentMethodType: String
    public let receiverAddress: String
    public let status: String
    public let updatedAt: String
    
    public struct AssetInfo: Codable {
        public let address: String?
        public let decimals: Int
        public let name: String
        public let symbol: String
        public let type: String
    }
}
