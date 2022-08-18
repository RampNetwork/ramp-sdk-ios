import Foundation

/// Parameters description and usage can be found at [Ramp Configuratoin Documentation](https://docs.ramp.network/configuration)
public struct Configuration: Decodable { // Decodable conformance is used in Flutter
    public enum Flow: String, CaseIterable, Decodable { // Decodable conformance is used in Flutter
        case onramp = "ONRAMP"
        case offramp = "OFFRAMP"
    }
    
    /// main URL
    public var url: String = Constants.defaultUrl
    
    /// query params
    public var containerNode: String?
    public var deepLinkScheme: String?
    public var defaultAsset: String?
    public var defaultFlow: Flow?
    public var enabledFlows: [Flow]?
    public var fiatCurrency: String?
    public var fiatValue: String?
    public var finalUrl: String?
    public var hostApiKey: String?
    public var hostAppName: String?
    public var hostLogoUrl: String?
    public var offrampWebhookV3Url: String?
    public var selectedCountryCode: String?
    public var swapAmount: String?
    public var swapAsset: String?
    public var userAddress: String?
    public var userEmailAddress: String?
    public var useSendCryptoCallback: Bool?
    public var useSendCryptoCallbackVersion: Int?
    public var variant: String { Constants.sdkVariant }
    public var webhookStatusUrl: String?
    
    public init() {}
}

extension Configuration {
    public enum Error: Swift.Error { case invalidUrl, invalidParameters }
    
    func buildUrl() throws -> URL {
        guard var urlComponents = URLComponents(string: url) else { throw Error.invalidUrl }
        urlComponents.path = "/"
        
        urlComponents.appendQueryItem(name: "containerNode", value: containerNode)
        urlComponents.appendQueryItem(name: "deepLinkScheme", value: deepLinkScheme)
        urlComponents.appendQueryItem(name: "defaultAsset", value: defaultAsset)
        if let defaultFlow = defaultFlow {
            urlComponents.appendQueryItem(name: "defaultFlow", value: defaultFlow.rawValue)
        }
        if let enabledFlows = enabledFlows {
            let value = enabledFlows.map(\.rawValue).joined(separator: ",")
            urlComponents.appendQueryItem(name: "enabledFlows", value: value)
        }
        urlComponents.appendQueryItem(name: "fiatCurrency", value: fiatCurrency)
        urlComponents.appendQueryItem(name: "fiatValue", value: fiatValue)
        urlComponents.appendQueryItem(name: "finalUrl", value: finalUrl)
        urlComponents.appendQueryItem(name: "hostApiKey", value: hostApiKey)
        urlComponents.appendQueryItem(name: "hostAppName", value: hostAppName)
        urlComponents.appendQueryItem(name: "hostLogoUrl", value: hostLogoUrl)
        urlComponents.appendQueryItem(name: "offrampWebhookV3Url", value: offrampWebhookV3Url)
        urlComponents.appendQueryItem(name: "selectedCountryCode", value: selectedCountryCode)
        urlComponents.appendQueryItem(name: "swapAmount", value: swapAmount)
        urlComponents.appendQueryItem(name: "swapAsset", value: swapAsset)
        urlComponents.appendQueryItem(name: "userAddress", value: userAddress)
        urlComponents.appendQueryItem(name: "userEmailAddress", value: userEmailAddress)
        if let useSendCryptoCallback = useSendCryptoCallback {
            let value = useSendCryptoCallback ? "true" : "false"
            urlComponents.appendQueryItem(name: "useSendCryptoCallback", value: value)
        }
        if let useSendCryptoCallbackVersion = useSendCryptoCallbackVersion {
            urlComponents.appendQueryItem(name: "useSendCryptoCallbackVersion", value: String(useSendCryptoCallbackVersion))
        }
        urlComponents.appendQueryItem(name: "variant", value: variant)
        urlComponents.appendQueryItem(name: "webhookStatusUrl", value: webhookStatusUrl)
        
        if let url = urlComponents.url { return url }
        else { throw Error.invalidParameters }
    }
}
