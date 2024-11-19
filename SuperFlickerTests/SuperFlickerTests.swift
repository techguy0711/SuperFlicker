import XCTest
@testable import SuperFlicker

class SuperFlickerTests: XCTestCase {

    var flickerMock: FlickerMock!

    override func setUp() {
        super.setUp()
        flickerMock = FlickerMock()
    }

    override func tearDown() {
        flickerMock = nil
        super.tearDown()
    }

    func testSearchPhotos_setsDidCallSearchFlag() async {
        let query = "mountain"

        await flickerMock.searchPhotos(query: query)

        XCTAssertTrue(flickerMock.didCallSearch, "The didCallSearch flag should be set to true when searchPhotos is called.")
    }

    func testShareImage_setsDidCallShareFlag() {
        let imageUrl = "https://example.com/image.jpg"

        flickerMock.shareImage(from: imageUrl)

        XCTAssertTrue(flickerMock.didCallShare, "The didCallShare flag should be set to true when shareImage is called.")
    }
}
