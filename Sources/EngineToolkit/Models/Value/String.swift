import Foundation

// TODO: The underscore is added here to avoid name collisions. Something better is needed.
public struct String_: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .string
    
    // ===============
    // Struct members
    // ===============
    
    public let value: String
    
    // =============
    // Constructors
    // =============
    
    public init(from value: String) {
        self.value = value
    }
}

public extension String_ {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case value, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(value, forKey: .value)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        // Decoding `value`
        value = try container.decode(String.self, forKey: .value)
    }
}
