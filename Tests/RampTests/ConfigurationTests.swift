import XCTest
@testable import Ramp

class ConfigurationTests: XCTestCase {
    
    func testEmptyConfiguration() throws {
        let configuration = Configuration()
        let url = try configuration.buildUrl()
        XCTAssertEqual(url.absoluteString, "https://buy.ramp.network/?variant=sdk-mobile")
    }
    
    // TODO: add more tests
}
