//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public struct NotarizedTransaction: Sendable, Codable, Hashable {
    public let signedIntent: SignedTransactionIntent
    public let notarySignature: Signature
    
    private enum CodingKeys: String, CodingKey {
        case signedIntent = "signed_intent"
        case notarySignature = "notary_signature"
    }
}
