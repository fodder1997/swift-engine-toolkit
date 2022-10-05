import Foundation

public struct EcdsaSecp256k1PublicKey: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .ecdsaSecp256k1PublicKey
    
    // ===============
    // Struct members
    // ===============
    
    public let publicKey: [UInt8]
    
    // =============
    // Constructors
    // =============
    
    public init(from publicKey: [UInt8]) {
        self.publicKey = publicKey
    }
    
    public init(from publicKey: String) throws {
        // TODO: Validation of length of array
        self.publicKey = [UInt8](hex: publicKey)
    }

}

public extension EcdsaSecp256k1PublicKey {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case publicKey = "public_key", type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(publicKey.toHexString(), forKey: .publicKey)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `publicKey`
        self = try Self(from: try container.decode(String.self, forKey: .publicKey))
    }
}
