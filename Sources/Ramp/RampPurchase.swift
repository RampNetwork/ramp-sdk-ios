import Foundation

public struct RampPurchase: Decodable {
    public let id: String
    public let endTime: String
    public let asset: AssetInfo
    public let receiverAddress: String
    public let cryptoAmount: String
    public let fiatCurrency: String
    public let fiatValue: Double
    public let assetExchangeRate: Double
    public let baseRampFee: Double
    public let networkFee: Double
    public let appliedFee: Double
    public let paymentMethodType: String
    public let finalTxHash: String?
    public let createdAt: String
    public let updatedAt: String
    public let status: String
    public let escrowAddress: String?
    public let escrowDetailsHash: String?
    
    public struct AssetInfo: Decodable {
        public let address: String?
        public let decimals: Int
        public let name: String
        public let symbol: String
        public let type: String
    }
}
