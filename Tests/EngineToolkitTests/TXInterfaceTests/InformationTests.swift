final class InformationTests: TestCase {
	
    func test__information() throws {
        let information = try sut.information().get()
        XCTAssertEqual(information, .init(packageVersion: "0.1.0"))
    }
}


