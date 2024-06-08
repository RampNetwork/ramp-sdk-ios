import Foundation

/// Parameters description and usage can be found at [Ramp Configuratoin Documentation](https://docs.ramp.network/configuration)
public struct Configuration: Codable, Equatable {
    public var containerNode: String?
    public var deepLinkScheme: String?
    public var defaultAsset: String?
    public var defaultFlow: String?
    public var enabledFlows: Set<String>?
    public var fiatCurrency: String?
    public var fiatValue: String?
    public var finalUrl: String?
    public var hostApiKey: String?
    public var hostAppName: String?
    public var hostLogoUrl: String?
    public var offrampAsset: String?
    public var offrampWebhookV3Url: String?
    public var paymentMethodType: String?
    public var selectedCountryCode: String?
    public var sdkType: String? = Constants.sdkType
    public var sdkVersion: String? = Constants.sdkVersion
    public var swapAmount: String?
    public var swapAsset: String?
    public var url: String = Constants.defaultUrl
    public var userAddress: String?
    public var userEmailAddress: String?
    public var useSendCryptoCallback: Bool?
    public var useSendCryptoCallbackVersion: String?
    public var variant: String? = Constants.sdkVariant
    public var webhookStatusUrl: String?
    
    public init() {}
}

public extension Configuration {
    enum Error: Swift.Error {
        case invalidUrl
        case invalidParameters
    }
    
    static let onramp = "ONRAMP"
    static let offramp = "OFFRAMP"
    
    func buildUrl() throws -> URL {
        guard var urlComponents = URLComponents(string: url) else {
            throw Error.invalidUrl
        }
        
        urlComponents.appendQueryItem(name: "containerNode", value: containerNode)
        urlComponents.appendQueryItem(name: "deepLinkScheme", value: deepLinkScheme)
        urlComponents.appendQueryItem(name: "defaultAsset", value: defaultAsset)
        urlComponents.appendQueryItem(name: "defaultFlow", value: defaultFlow)
        urlComponents.appendQueryItem(name: "enabledFlows", value: enabledFlows?.joined(separator: ","))
        urlComponents.appendQueryItem(name: "fiatCurrency", value: fiatCurrency)
        urlComponents.appendQueryItem(name: "fiatValue", value: fiatValue)
        urlComponents.appendQueryItem(name: "finalUrl", value: finalUrl)
        urlComponents.appendQueryItem(name: "hostApiKey", value: hostApiKey)
        urlComponents.appendQueryItem(name: "hostAppName", value: hostAppName)
        urlComponents.appendQueryItem(name: "hostLogoUrl", value: hostLogoUrl)
        urlComponents.appendQueryItem(name: "offrampAsset", value: offrampAsset)
        urlComponents.appendQueryItem(name: "offrampWebhookV3Url", value: offrampWebhookV3Url)
        urlComponents.appendQueryItem(name: "paymentMethodType", value: paymentMethodType)
        urlComponents.appendQueryItem(name: "selectedCountryCode", value: selectedCountryCode)
        urlComponents.appendQueryItem(name: "sdkType", value: sdkType)
        urlComponents.appendQueryItem(name: "sdkVersion", value: sdkVersion)
        urlComponents.appendQueryItem(name: "swapAmount", value: swapAmount)
        urlComponents.appendQueryItem(name: "swapAsset", value: swapAsset)
        urlComponents.appendQueryItem(name: "userAddress", value: userAddress)
        urlComponents.appendQueryItem(name: "userEmailAddress", value: userEmailAddress)
        urlComponents.appendQueryItem(name: "useSendCryptoCallback", value: useSendCryptoCallback)
        urlComponents.appendQueryItem(name: "useSendCryptoCallbackVersion", value: useSendCryptoCallbackVersion)
        urlComponents.appendQueryItem(name: "variant", value: variant)
        urlComponents.appendQueryItem(name: "webhookStatusUrl", value: webhookStatusUrl)
        
        if let url = urlComponents.url {
            return url
        } else {
            throw Error.invalidParameters
        }
    }
}
