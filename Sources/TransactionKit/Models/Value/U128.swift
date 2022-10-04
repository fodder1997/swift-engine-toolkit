import Foundation

public struct U128: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .u128
    
    // ===============
    // Struct members
    // ===============
    
    // TODO: Swift does not have any 128-bit types, so, we store this as a string. We need a better solution to this.
    public let value: String
    
    // =============
    // Constructors
    // =============
    
    init(from value: String) {
        self.value = value
    }

}

public extension U128 {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(String(value), forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `value`
        // TODO: Validation is needed here to ensure that this numeric and in the range of an Unsigned 128 bit number
        value = try values.decode(String.self, forKey: .value)
    }
}
