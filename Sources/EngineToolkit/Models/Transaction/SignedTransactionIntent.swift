//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-05.
//

import Foundation

public struct SignedTransactionIntent: Sendable, Codable, Hashable {
    public let intent: TransactionIntent
    public let intentSignatures: [Engine.SignatureWithPublicKey]
    
    public init(
        intent: TransactionIntent,
        intentSignatures: [Engine.SignatureWithPublicKey]
    ) {
        self.intent = intent
        self.intentSignatures = intentSignatures
    }
    
    private enum CodingKeys: String, CodingKey {
        case intent = "intent"
        case intentSignatures = "intent_signatures"
    }
}
