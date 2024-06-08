import XCTest
@testable import Ramp

class ConfigurationTests: XCTestCase {
    struct Constants {
        static let defaultUrl = "https://app.ramp.network?sdkType=iOS&sdkVersion=4.0.2&variant=sdk-mobile"
    }
    
    func testEmptyConfiguration() throws {
        let configuration = Configuration()
        let url = try configuration.buildUrl()
        XCTAssertEqual(url.absoluteString, Constants.defaultUrl)
    }
}
