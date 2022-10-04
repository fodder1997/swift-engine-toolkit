import Foundation

public struct CreateProofFromBucket: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = InstructionKind.CreateProofFromBucket
    
    // ===============
    // Struct members
    // ===============
    
    public let bucket: Bucket
    public let intoProof: Proof
    
    // =============
    // Constructors
    // =============
    
    init(from bucket: Bucket, intoProof: Proof) {
        self.bucket = bucket
        self.intoProof = intoProof
    }
}

public extension CreateProofFromBucket {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys : String, CodingKey {
        case type = "instruction"
        case bucket
        case intoProof = "into_proof"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(bucket, forKey: .bucket)
        try container.encode(intoProof, forKey: .intoProof)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let values: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try values.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw DecodeError.InstructionTypeDiscriminatorMismatch(Self.kind, kind)
        }
        
        let bucket: Bucket = try values.decode(Bucket.self, forKey: .bucket)
        let intoProof: Proof = try values.decode(Proof.self, forKey: .intoProof)
        
        self = Self(from: bucket, intoProof: intoProof)
    }
}
