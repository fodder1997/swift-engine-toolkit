//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public extension TransactionManifest {
    
    // =======================
    // Coding Keys Definition
    // =======================
    private enum CodingKeys: String, CodingKey {
        case type
        case instructions
        case blobs
    }
    
    // ======================
    // Encoding and Decoding
    // ======================
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let hexBlobs = blobs.map { $0.toHexString() }
        
        try container.encode(instructions, forKey: .instructions)
        try container.encode(hexBlobs, forKey: .blobs)
    }
    
    init(from decoder: Decoder) throws {
        // Checking for type discriminator
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let instructions: ManifestInstructions = try container.decode(ManifestInstructions.self, forKey: .instructions)
        let hexBlobs = (try? container.decode(Array<String>.self, forKey: .blobs)) ?? []
        let blobs = hexBlobs.map { Array<UInt8>(hex: $0) }
        self = Self(from: instructions, blobs: blobs)
    }
}
