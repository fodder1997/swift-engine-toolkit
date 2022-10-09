import Foundation

public struct ComponentAddress: ValueProtocol, AddressProtocol {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .componentAddress
    public func embedValue() -> Value {
        .componentAddress(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let address: String
    
    // =============
    // Constructors
    // =============
    
    public init(address: String) {
        // TODO: Perform some simple Bech32m validation.
        self.address = address
    }

}

public extension ComponentAddress {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case address, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(String(address), forKey: .address)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `address`
        try self.init(address: container.decode(String.self, forKey: .address))
    }
}
