import XCTest
@testable import Ramp

class ConfigurationTests: XCTestCase {
    
    struct Constants {
        static let defaultUrl = "https://buy.ramp.network/?variant=sdk-mobile"
    }
    
    func testEmptyConfiguration() throws {
        let configuration = Configuration()
        let url = try configuration.buildUrl()
        XCTAssertEqual(url.absoluteString, Constants.defaultUrl)
    }
}
