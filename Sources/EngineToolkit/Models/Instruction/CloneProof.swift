import Foundation

public struct CloneProof: Sendable, Codable, Hashable {
    // Type name, used as a discriminator
    public static let kind: InstructionKind = .cloneProof
    
    // ===============
    // Struct members
    // ===============
    
    public let proof: Proof
    public let intoProof: Proof
    
    // =============
    // Constructors
    // =============
    
    public init(from proof: Proof, intoProof: Proof) {
        self.proof = proof
        self.intoProof = intoProof
    }
}

public extension CloneProof {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type = "instruction"
        case proof
        case intoProof = "into_proof"
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Self.kind, forKey: .type)
        
        try container.encode(proof, forKey: .proof)
        try container.encode(intoProof, forKey: .intoProof)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind: InstructionKind = try container.decode(InstructionKind.self, forKey: .type)
        if kind != Self.kind {
            throw InternalDecodingFailure.instructionTypeDiscriminatorMismatch(expected: Self.kind, butGot: kind)
        }
        
        let proof: Proof = try container.decode(Proof.self, forKey: .proof)
        let intoProof: Proof = try container.decode(Proof.self, forKey: .intoProof)
        
        self = Self(from: proof, intoProof: intoProof)
    }
}
