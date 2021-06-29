import Foundation

/// Parameters description and usage can be found at [Ramp Configuratoin Documentation](https://docs.ramp.network/configuration)
public struct Configuration {
    public var swapAsset: String? = nil
    public var swapAmount: String? = nil
    public var fiatCurrency: String? = nil
    public var fiatValue: String? = nil
    public var userAddress: String? = nil
    public var hostLogoUrl: String? = nil
    public var hostAppName: String? = nil
    public var userEmailAddress: String? = nil
    public var selectedCountryCode: String? = nil
    public var defaultAsset: String? = nil
    public var url: String? = nil
    public var webhookStatusUrl: String? = nil
    public var finalUrl: String? = nil
    private let variant: String = "sdk-mobile"
    public var containerNode: String? = nil
    public var hostApiKey: String? = nil
    public var deepLinkScheme: String? = nil // undocumented

    // Generated Memberwise Initializer
    public init(swapAsset: String? = nil, swapAmount: String? = nil, fiatCurrency: String? = nil, fiatValue: String? = nil, userAddress: String? = nil, hostLogoUrl: String? = nil, hostAppName: String? = nil, userEmailAddress: String? = nil, selectedCountryCode: String? = nil, defaultAsset: String? = nil, url: String? = nil, webhookStatusUrl: String? = nil, finalUrl: String? = nil, containerNode: String? = nil, hostApiKey: String? = nil, deepLinkScheme: String? = nil) {
        self.swapAsset = swapAsset
        self.swapAmount = swapAmount
        self.fiatCurrency = fiatCurrency
        self.fiatValue = fiatValue
        self.userAddress = userAddress
        self.hostLogoUrl = hostLogoUrl
        self.hostAppName = hostAppName
        self.userEmailAddress = userEmailAddress
        self.selectedCountryCode = selectedCountryCode
        self.defaultAsset = defaultAsset
        self.url = url
        self.webhookStatusUrl = webhookStatusUrl
        self.finalUrl = finalUrl
        self.containerNode = containerNode
        self.hostApiKey = hostApiKey
        self.deepLinkScheme = deepLinkScheme
    }
}

extension Configuration {
    public enum Error: Swift.Error { case invalidUrl, invalidParameters }
    private static let defaultUrl: String = "https://buy.ramp.network"
    
    func buildUrl() throws -> URL {
        let url = url ?? Configuration.defaultUrl
        guard var urlComponents = URLComponents(string: url) else { throw Error.invalidUrl }
        
        urlComponents.appendQueryItem(name: "swapAsset", value: swapAsset)
        urlComponents.appendQueryItem(name: "swapAmount", value: swapAmount)
        urlComponents.appendQueryItem(name: "fiatCurrency", value: fiatCurrency)
        urlComponents.appendQueryItem(name: "fiatValue", value: fiatValue)
        urlComponents.appendQueryItem(name: "userAddress", value: userAddress)
        urlComponents.appendQueryItem(name: "hostLogoUrl", value: hostLogoUrl)
        urlComponents.appendQueryItem(name: "hostAppName", value: hostAppName)
        urlComponents.appendQueryItem(name: "userEmailAddress", value: userEmailAddress)
        urlComponents.appendQueryItem(name: "selectedCountryCode", value: selectedCountryCode)
        urlComponents.appendQueryItem(name: "defaultAsset", value: defaultAsset)
        urlComponents.appendQueryItem(name: "webhookStatusUrl", value: webhookStatusUrl)
        urlComponents.appendQueryItem(name: "finalUrl", value: finalUrl)
        urlComponents.appendQueryItem(name: "variant", value: variant)
        urlComponents.appendQueryItem(name: "containerNode", value: containerNode)
        urlComponents.appendQueryItem(name: "hostApiKey", value: hostApiKey)
        urlComponents.appendQueryItem(name: "deepLinkScheme", value: deepLinkScheme)
        
        if let url = urlComponents.url { return url }
        else { throw Error.invalidParameters }
    }
}

// MARK: URL components construction

private extension URLComponents {
    mutating func appendQueryItem(name: String, value: String?) {
        guard let value = value else { return }
        let queryItem = URLQueryItem(name: name, value: value)
        if queryItems == nil { queryItems = [queryItem] }
        else { queryItems!.append(queryItem) }
    }
}
