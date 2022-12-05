@testable import EngineToolkit

final class ConvertManifestTests: TestCase {
	
    override func setUp() {
        debugPrint = true
        super.setUp()
    }
    
    func test__convertManifest_from_string_to_json_does_not_throw_ed25519() throws {
        let request = makeRequest(outputFormat: .json, manifest: try testTransactionEd25519(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest)
        XCTAssertNoThrow(try sut.convertManifest(request: request).get())
    }
	
	func test__convertManifest_from_string_to_string_returns_the_same_manifest_ed25519() throws {
        let manifest: TransactionManifest = try testTransactionEd25519(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest
		let request = makeRequest(outputFormat: .string, manifest: manifest)
        let converted = try sut.convertManifest(request: request).get()
		XCTAssertEqual(manifest, converted)
	}
    
    
    func test__convertManifest_from_string_to_json_does_not_throw_secp256k1() throws {
        let request = makeRequest(outputFormat: .json, manifest: try testTransactionSecp256k1(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest)
        XCTAssertNoThrow(try sut.convertManifest(request: request).get())
    }
    
    func test__convertManifest_from_string_to_string_returns_the_same_manifest_secp256k1() throws {
        let manifest: TransactionManifest = try testTransactionSecp256k1(signerCount: 0).notarizedTransaction.signedIntent.intent.manifest
        let request = makeRequest(outputFormat: .string, manifest: manifest)
        let converted = try sut.convertManifest(request: request).get()
        XCTAssertEqual(manifest, converted)
    }
    
    func test__convertManifest_any_value_succeeds() throws {
        let manifestString = """
            TAKE_FROM_WORKTOP ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag") Bucket("temp1");

            CREATE_PROOF_FROM_AUTH_ZONE ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag") Proof("temp2");

            CALL_METHOD
                ComponentAddress("component_sim1q2f9vmyrmeladvz0ejfttcztqv3genlsgpu9vue83mcs835hum")
                "with_all_types"

                # Global address types
                PackageAddress("package_sim1qyqzcexvnyg60z7lnlwauh66nhzg3m8tch2j8wc0e70qkydk8r")
                ComponentAddress("account_sim1q0u9gxewjxj8nhxuaschth2mgencma2hpkgwz30s9wlslthace")
                ResourceAddress("resource_sim1qq8cays25704xdyap2vhgmshkkfyr023uxdtk59ddd4qs8cr5v")
                SystemAddress("system_sim1qne8qu4seyvzfgd94p3z8rjcdl3v0nfhv84judpum2lq7x4635")

                # RE nodes types
                Component("000000000000000000000000000000000000000000000000000000000000000005000000")
                KeyValueStore("000000000000000000000000000000000000000000000000000000000000000005000000")
                Bucket("temp1")
                Proof("temp2")
                Vault("000000000000000000000000000000000000000000000000000000000000000005000000")

                # Other interpreted types
                Expression("ALL_WORKTOP_RESOURCES")
                NonFungibleAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag", "value")
                NonFungibleAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag", 123u32)
                NonFungibleAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag", 456u64)
                NonFungibleAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag", Bytes("031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f"))
                NonFungibleAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag", 1234567890u128)

                # Uninterpreted
                Hash("2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824")
                EcdsaSecp256k1PublicKey("0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798")
                EcdsaSecp256k1Signature("0079224ea514206706298d8d620f660828f7987068d6d02757e6f3cbbf4a51ab133395db69db1bc9b2726dd99e34efc252d8258dcb003ebaba42be349f50f7765e")
                EddsaEd25519PublicKey("4cb5abf6ad79fbf5abbccafcc269d85cd2651ed4b885b5869f241aedf0a5ba29")
                EddsaEd25519Signature("ce993adc51111309a041faa65cbcf1154d21ed0ecdc2d54070bc90b9deb744aa8605b3f686fa178fba21070b4a4678e54eee3486a881e0e328251cd37966de09")
                Decimal("1.2")
                PreciseDecimal("1.2")
                NonFungibleId(Bytes("031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f"))
                NonFungibleId(12u32)
                NonFungibleId(12345u64)
                NonFungibleId(1234567890u128)
                NonFungibleId("SomeId");
            """;
        
        let expectedManifest = try TransactionManifest {
            let xrdResourceAddress: ResourceAddress = "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag"
            
            TakeFromWorktop(
                resourceAddress: xrdResourceAddress,
                bucket: "temp1"
            )
            CreateProofFromAuthZone(
                resourceAddress: xrdResourceAddress,
                intoProof: "temp2"
            )
            try CallMethod(
                receiver: ComponentAddress("component_sim1q2f9vmyrmeladvz0ejfttcztqv3genlsgpu9vue83mcs835hum"),
                methodName: "with_all_types"
            ) {
                // Global address types
                PackageAddress("package_sim1qyqzcexvnyg60z7lnlwauh66nhzg3m8tch2j8wc0e70qkydk8r")
                ComponentAddress("account_sim1q0u9gxewjxj8nhxuaschth2mgencma2hpkgwz30s9wlslthace")
                ResourceAddress("resource_sim1qq8cays25704xdyap2vhgmshkkfyr023uxdtk59ddd4qs8cr5v")
                SystemAddress("system_sim1qne8qu4seyvzfgd94p3z8rjcdl3v0nfhv84judpum2lq7x4635")
                
                // RE nodes types
                try Component(hex: "000000000000000000000000000000000000000000000000000000000000000005000000")
                try KeyValueStore(hex: "000000000000000000000000000000000000000000000000000000000000000005000000")
                Bucket("temp1")
                Proof("temp2")
                try Vault(hex: "000000000000000000000000000000000000000000000000000000000000000005000000")
                
                // Other interpreted types
                Expression("ALL_WORKTOP_RESOURCES")
                NonFungibleAddress(resourceAddress: ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag"), nonFungibleId: .string("value"))
                NonFungibleAddress(resourceAddress: ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag"), nonFungibleId: .u32(123))
                NonFungibleAddress(resourceAddress: ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag"), nonFungibleId: .u64(456))
                NonFungibleAddress(resourceAddress: ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag"), nonFungibleId: try .bytes([UInt8](hex: "031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f")))
                NonFungibleAddress(resourceAddress: ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag"), nonFungibleId: .uuid("1234567890"))
                
                // Uninterpreted
                try Hash(hex: "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824")
                try EcdsaSecp256k1PublicKey(hex: "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798")
                try EcdsaSecp256k1Signature(hex: "0079224ea514206706298d8d620f660828f7987068d6d02757e6f3cbbf4a51ab133395db69db1bc9b2726dd99e34efc252d8258dcb003ebaba42be349f50f7765e")
                try EddsaEd25519PublicKey(hex: "4cb5abf6ad79fbf5abbccafcc269d85cd2651ed4b885b5869f241aedf0a5ba29")
                try EddsaEd25519Signature(hex: "ce993adc51111309a041faa65cbcf1154d21ed0ecdc2d54070bc90b9deb744aa8605b3f686fa178fba21070b4a4678e54eee3486a881e0e328251cd37966de09")
                try Decimal_(string: "1.2")
                PreciseDecimal("1.2")
                try NonFungibleId.bytes([UInt8](hex: "031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f"))
                NonFungibleId.u32(12)
                NonFungibleId.u64(12345)
                NonFungibleId.uuid("1234567890")
                NonFungibleId.string("SomeId")
            }
        }
        
        let transactionManifest = TransactionManifest(instructions: .string(manifestString))
        let convertedManifest = try sut.convertManifest(request: makeRequest(outputFormat: .json, manifest: transactionManifest)).get()
        
        XCTAssertEqual(expectedManifest, convertedManifest)
    }
    
    func test__convertManifest_callMethod_succeeds() throws {
        let manifestString = """
            # Inovke scrypto method (both global and local)
            CALL_METHOD ComponentAddress("component_sim1qgvyxt5rrjhwctw7krgmgkrhv82zuamcqkq75tkkrwgs00m736") "free_xrd";
            CALL_METHOD Component("000000000000000000000000000000000000000000000000000000000000000005000000") "free_xrd";

            # Invoke native method (ref only)
            TAKE_FROM_WORKTOP ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag") Bucket("xrd");
            CREATE_PROOF_FROM_AUTH_ZONE ResourceAddress("resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag") Proof("proof");
            CALL_NATIVE_METHOD Bucket("xrd") "get_resource_address";
            CALL_NATIVE_METHOD Bucket(1u32) "get_resource_address";
            CALL_NATIVE_METHOD Proof("proof") "get_resource_address";
            CALL_NATIVE_METHOD Proof(1u32) "get_resource_address";
            CALL_NATIVE_METHOD AuthZoneStack(1u32) "drain";
            CALL_NATIVE_METHOD Worktop "drain";
            CALL_NATIVE_METHOD KeyValueStore("000000000000000000000000000000000000000000000000000000000000000005000000") "method";
            CALL_NATIVE_METHOD NonFungibleStore("000000000000000000000000000000000000000000000000000000000000000005000000") "method";
            CALL_NATIVE_METHOD Component("000000000000000000000000000000000000000000000000000000000000000005000000") "add_access_check";
            CALL_NATIVE_METHOD EpochManager("000000000000000000000000000000000000000000000000000000000000000005000000") "get_transaction_hash";
            CALL_NATIVE_METHOD Vault("000000000000000000000000000000000000000000000000000000000000000005000000") "get_resource_address";
            CALL_NATIVE_METHOD ResourceManager("000000000000000000000000000000000000000000000000000000000000000000000005") "burn";
            CALL_NATIVE_METHOD Package("000000000000000000000000000000000000000000000000000000000000000000000005") "method";
            CALL_NATIVE_METHOD Global("resource_sim1qrc4s082h9trka3yrghwragylm3sdne0u668h2sy6c9sckkpn6") "method";
            """;
        
        let expectedManifest = try TransactionManifest {
            let reNodeIdentifier1 = try RENodeIdentifier(hex: "000000000000000000000000000000000000000000000000000000000000000005000000")
            let reNodeIdentifier2 = try RENodeIdentifier(hex: "000000000000000000000000000000000000000000000000000000000000000000000005")
            
            CallMethod(
                receiver: ComponentAddress("component_sim1qgvyxt5rrjhwctw7krgmgkrhv82zuamcqkq75tkkrwgs00m736"),
                methodName: "free_xrd"
            )
            CallMethod(
                receiver: Component(identifier: reNodeIdentifier1),
                methodName: "free_xrd"
            )
            
            TakeFromWorktop (
                resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag",
                bucket: "xrd"
            )
            CreateProofFromAuthZone(
                resourceAddress: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqzqu57yag",
                intoProof: "proof"
            )
            
            CallNativeMethod(
                receiver: .bucket("xrd"),
                methodName: "get_resource_address"
            )
            CallNativeMethod(
                receiver: .bucket(1),
                methodName: "get_resource_address"
            )
            
            CallNativeMethod(
                receiver: .proof("proof"),
                methodName: "get_resource_address"
            )
            CallNativeMethod(
                receiver: .proof(1),
                methodName: "get_resource_address"
            )
            
            CallNativeMethod(
                receiver: .authZoneStack(1),
                methodName: "drain"
            )
            CallNativeMethod(
                receiver: .worktop,
                methodName: "drain"
            )
            
            CallNativeMethod(
                receiver: .keyValueStore(reNodeIdentifier1),
                methodName: "method"
            )
            CallNativeMethod(
                receiver: .nonFungibleStore(reNodeIdentifier1),
                methodName: "method"
            )
            CallNativeMethod(
                receiver: .component(reNodeIdentifier1),
                methodName: "add_access_check"
            )
            CallNativeMethod(
                receiver: .epochManager(reNodeIdentifier1),
                methodName: "get_transaction_hash"
            )
            CallNativeMethod(
                receiver: .vault(reNodeIdentifier1),
                methodName: "get_resource_address"
            )
            
            CallNativeMethod(
                receiver: .resourceManager(reNodeIdentifier2),
                methodName: "burn"
            )
            CallNativeMethod(
                receiver: .package(reNodeIdentifier2),
                methodName: "method"
            )
            CallNativeMethod(
                receiver: RENode.global("resource_sim1qrc4s082h9trka3yrghwragylm3sdne0u668h2sy6c9sckkpn6"),
                methodName: "method"
            )
        }
        
        let transactionManifest = TransactionManifest(instructions: .string(manifestString))
        let convertedManifest = try sut.convertManifest(request: makeRequest(outputFormat: .json, manifest: transactionManifest)).get()
        
        XCTAssertEqual(expectedManifest, convertedManifest)
    }
    
    func test__convertManifest_callNativeFunction_succeeds() throws {
        let manifestString = """
            # Inovke scrypto function
            CALL_FUNCTION PackageAddress("package_sim1qy4hrp8a9apxldp5cazvxgwdj80cxad4u8cpkaqqnhlsa3lfpe") "Blueprint" "function";

            # Invoke native function
            CALL_NATIVE_FUNCTION "EpochManager" "create";
            CALL_NATIVE_FUNCTION "ResourceManager" "create";
            CALL_NATIVE_FUNCTION "Package" "publish";
            CALL_NATIVE_FUNCTION "TransactionProcessor" "run";
            """;
        
        let expectedManifest = TransactionManifest {
            // Inovke scrypto function
            CallFunction(
                packageAddress: "package_sim1qy4hrp8a9apxldp5cazvxgwdj80cxad4u8cpkaqqnhlsa3lfpe",
                blueprintName: "Blueprint",
                functionName: "function"
            )
            
            // Invoke native function
            CallNativeFunction(blueprintName: "EpochManager", functionName: "create")
            CallNativeFunction(blueprintName: "ResourceManager", functionName: "create")
            CallNativeFunction(blueprintName: "Package", functionName: "publish")
            CallNativeFunction(blueprintName: "TransactionProcessor", functionName: "run")
        }
        
        let transactionManifest = TransactionManifest(instructions: .string(manifestString))
        let convertedManifest = try sut.convertManifest(request: makeRequest(outputFormat: .json, manifest: transactionManifest)).get()
        
        XCTAssertEqual(expectedManifest, convertedManifest)
    }
}

func makeRequest(
    outputFormat: ManifestInstructionsKind = .json,
    manifest: TransactionManifest
) -> ConvertManifestRequest {
    ConvertManifestRequest(
        transactionVersion: 1,
        manifest: manifest,
        outputFormat: outputFormat,
        networkId: .simulator
    )
}

extension ResourceAddress {
    static let mock: Self = .init(address: "resource_sim1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqshxgp7h")
}
