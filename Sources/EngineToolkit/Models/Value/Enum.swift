import Foundation

public struct Enum: ValueProtocol {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .enum
    public func embedValue() -> Value {
        .enum(self)
    }
    
    // ===============
    // Struct members
    // ===============
    
    public let variant: String
    public let fields: [Value]
    
    // =============
    // Constructors
    // =============
    
    public init(_ variant: String, fields: [Value]) {
        self.variant = variant
        self.fields = fields
    }
    
    public init(
        _ variant: String,
        @ValuesBuilder fields: () throws -> [any ValueProtocol]
    ) rethrows {
        try self.init(variant, fields: fields().map { $0.embedValue() })
    }
    public init(
        _ variant: String,
        @SpecificValuesBuilder fields: () throws -> [Value]
    ) rethrows {
        try self.init(variant, fields: fields())
    }
    
}

public extension Enum {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case variant
        case type
        case fields
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(variant, forKey: .variant)
        try container.encode(fields, forKey: .fields)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
   
        try self.init(
            container.decode(String.self, forKey: .variant),
            fields: container.decode([Value].self, forKey: .fields)
        )
    }
}
