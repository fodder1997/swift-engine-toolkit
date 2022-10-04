import Foundation

public struct Tuple: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .tuple
    
    // ===============
    // Struct members
    // ===============
    
    public let elements: Array<Value>
    
    // =============
    // Constructors
    // =============
    
    init(from elements: Array<Value>) {
        self.elements = elements
    }
}

public extension Tuple {
    
 
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case elements, type
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(elements, forKey: .elements)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try values.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.valueTypeDiscriminatorMismatch(Self.kind, kind)
        }
    
        // Decoding `elements`
        // TODO: Validate that all elements are of type `elementType`
        elements = try values.decode(Array<Value>.self, forKey: .elements)
    }
}
