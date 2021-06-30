import Foundation

public struct RampPurchase: Decodable {
    let id: String
    let endTime: Date
    let asset: AssetInfo
    let receiverAddress: String
    let cryptoAmount: String
    let fiatCurrency: String
    let fiatValue: Double
    let assetExchangeRate: Double
    let baseRampFee: Double
    let networkFee: Double
    let appliedFee: Double
    let paymentMethodType: PaymentMethodType
    let finalTxHash: String?
    let createdAt: Date
    let updatedAt: Date
    let status: PurchaseStatus
    let escrowAddress: String?
    let escrowDetailsHash: String?
    
    struct AssetInfo: Decodable {
        let address: String?
        let decimals: Int
        let name: String
        let symbol: String
        let type: String
    }

    enum PaymentMethodType: String, Decodable {
        case manualBankTransfer = "MANUAL_BANK_TRANSFER"
        case autoBankTransfer = "AUTO_BANK_TRANSFER"
        case cardPayment = "CARD_PAYMENT"
        case applePay = "APPLE_PAY"
    }
    
    enum PurchaseStatus: String, Decodable {
        case initialized = "INITIALIZED"
    }
}
