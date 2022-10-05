public struct InformationRequest: Sendable, Codable, Hashable {}


public struct InformationResponse: Sendable, Codable, Hashable {
    
    public let packageVersion: String
    public init(packageVersion: String) {
        self.packageVersion = packageVersion
    }
    
    private enum CodingKeys: String, CodingKey {
        case packageVersion = "package_version"
    }
}
