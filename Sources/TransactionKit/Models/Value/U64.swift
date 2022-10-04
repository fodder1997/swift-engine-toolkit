import Foundation;

public struct U64: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = ValueKind.U64
    
    // ===============
    // Struct members
    // ===============
    public let value: UInt64
    
    // =============
    // Constructors
    // =============
    
    init(from value: UInt64) {
        self.value = value
    }

}

public extension U64 {
    
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
            throw DecodeError.ValueTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        // Decoding `value`
        let valueString: String = try values.decode(String.self, forKey: .value)
        if let value = UInt64(valueString) {
            self.value = value
        } else {
            throw DecodeError.ParsingError
        }
    }
}
