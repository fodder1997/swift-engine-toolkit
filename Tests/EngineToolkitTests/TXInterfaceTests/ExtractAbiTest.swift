final class ExtractAbiTest: TestCase {
    
    func test__extractAbi() throws {
        let packageWasm = try resource(named: "package", extension: "wasm")
        let packageAbi = try resource(named: "package", extension: "abi")

        let extractAbiRequest = ExtractAbiRequest(packageWasm: .init(packageWasm))
        let extractAbiResponse = try sut.extractAbiRequest(request: extractAbiRequest).get()

        XCTAssertEqual(extractAbiResponse.abi.toHexString().prefix(32), packageAbi.toHexString().prefix(32))
    }
}

func resource(
    named fileName: String,
    extension fileExtension: String
) throws -> Data {
    let fileURL = Bundle.module.url(forResource: fileName, withExtension: fileExtension)
    return try Data(contentsOf: fileURL!)
}

