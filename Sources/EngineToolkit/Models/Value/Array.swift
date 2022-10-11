import Foundation

public struct Array_: ValueProtocol, Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: ValueKind = .array
    public func embedValue() -> Value {
        .array(self)
    }
    
    // MARK: Stored properties
    public let elementType: ValueKind
    public let elements: [Value]
    
    // MARK: Init
    
    public init(
        elementType: ValueKind,
        elements: [Value]
    ) throws {
        self.elementType = elementType
        guard elements.allSatisfy({ $0.kind == elementType }) else {
            throw Error.homogeneousArrayRequired
        }
        self.elements = elements
    }
    
    public init(
        elementType: ValueKind,
        @ValuesBuilder buildValues: () throws -> [ValueProtocol]
    ) throws {
        try self.init(
            elementType: elementType,
            elements: buildValues().map { $0.embedValue() }
        )
    }
    
    public init(
        elementType: ValueKind,
        @SpecificValuesBuilder buildValues: () throws -> [Value]
    ) throws {
        try self.init(
            elementType: elementType,
            elements: buildValues()
        )
    }
}

public extension Array_ {
    enum Error: String, Swift.Error, Sendable, Hashable {
        case homogeneousArrayRequired
    }
}

public extension Array_ {
    
    // MARK: CodingKeys
    private enum CodingKeys: String, CodingKey {
        case elements, elementType = "element_type", type
    }
    
    // MARK: Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(elements, forKey: .elements)
        try container.encode(elementType, forKey: .elementType)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: ValueKind = try container.decode(ValueKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.valueTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }

        try self.init(
            elementType: container.decode(ValueKind.self, forKey: .elementType),
            elements: container.decode([Value].self, forKey: .elements)
        )
    }
}
