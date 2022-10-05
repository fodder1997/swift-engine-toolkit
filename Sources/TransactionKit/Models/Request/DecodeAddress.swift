public struct DecodeAddressRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let address: String
    
    // =============
    // Constructors
    // =============
    
    public init(from address: String) {
        self.address = address
    }
}

public struct DecodeAddressResponse: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let networkId: UInt8
    public let networkName: String
    public let entityType: AddressKind
    public let data: Array<UInt8>
    public let hrp: String
    public let address: Address
}

public extension DecodeAddressResponse {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case networkId = "network_id"
        case networkName = "network_name"
        case entityType = "entity_type"
        case data
        case hrp
        case address
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(networkId, forKey: .networkId)
        try container.encode(networkName, forKey: .networkName)
        try container.encode(entityType, forKey: .entityType)
        try container.encode(data.toHexString(), forKey: .data)
        try container.encode(hrp, forKey: .hrp)
        try container.encode(address, forKey: .address)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        networkId = try container.decode(UInt8.self, forKey: .networkId)
        networkName = try container.decode(String.self, forKey: .networkName)
        entityType = try container.decode(AddressKind.self, forKey: .entityType)
        data = Array<UInt8>(hex: try container.decode(String.self, forKey: .data))
        hrp = try container.decode(String.self, forKey: .hrp)
        address = try container.decode(Address.self, forKey: .address)
    }
}

public enum AddressKind: String, Codable, Sendable, Hashable {
    case resource
    case package

    case accountComponent
    case systemComponent
    case normalComponent
}

public enum Address: Sendable, Codable, Hashable {
    case packageAddress(PackageAddress)
    case componentAddress(ComponentAddress)
    case resourceAddress(ResourceAddress)
}
