public struct DecompileUnknownTransactionIntentRequest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    public let compiledUnknownIntent: Array<UInt8>
    public let manifestInstructionsOutputFormat: ManifestInstructionsKind
    
    // =============
    // Constructors
    // =============
    
    public init(from compiledUnknownIntent: Array<UInt8>, manifestInstructionsOutputFormat: ManifestInstructionsKind) {
        self.compiledUnknownIntent = compiledUnknownIntent
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
    
    public init(from compiledUnknownIntent: String, manifestInstructionsOutputFormat: ManifestInstructionsKind) throws {
        self.compiledUnknownIntent = Array<UInt8>(hex: compiledUnknownIntent)
        self.manifestInstructionsOutputFormat = manifestInstructionsOutputFormat
    }
}

public extension DecompileUnknownTransactionIntentRequest {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case compiledUnknownIntent = "compiled_unknown_intent"
        case manifestInstructionsOutputFormat = "manifest_instructions_output_format"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(compiledUnknownIntent.toHexString(), forKey: .compiledUnknownIntent)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        self = try Self(from: try values.decode(String.self, forKey: .compiledUnknownIntent), manifestInstructionsOutputFormat: try values.decode(ManifestInstructionsKind.self, forKey: .manifestInstructionsOutputFormat))
    }
}

public enum DecompileUnknownTransactionIntentResponse: Sendable, Codable, Hashable {
    // ==============
    // Enum Variants
    // ==============
    
    case transactionIntent(DecompileTransactionIntentResponse)
    case signedTransactionIntent(DecompileSignedTransactionIntentResponse)
    case notarizedTransactionIntent(DecompileNotarizedTransactionIntentResponse)
}

public extension DecompileUnknownTransactionIntentResponse {
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case variant
        case type
        case field
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: SingleValueEncodingContainer = encoder.singleValueContainer()
        
        switch self {
            case .transactionIntent(let intent):
                try container.encode(intent)
            case .signedTransactionIntent(let intent):
                try container.encode(intent)
            case .notarizedTransactionIntent(let intent):
                try container.encode(intent)
        }
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        do {
            self = .transactionIntent(try values.decode(DecompileTransactionIntentResponse.self))
        } catch {
            do {
                self = .signedTransactionIntent(try values.decode(DecompileSignedTransactionIntentResponse.self))
            } catch {
                self = .notarizedTransactionIntent(try values.decode(DecompileNotarizedTransactionIntentResponse.self))
            }
        }
    }
}
