//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2022-10-09.
//

@testable import EngineToolkit


final class MapTests: TestCase {
    func test_error_is_thrown_for_odd_key_value_pairs() throws {
        
        XCTAssert(
            error: Map.Error.requiredEvenNumberOfValues,
            thrownBy: try Map(
                keyType: .string,
                valueType: .u8
            ) {
                String_("key0")
            }
            
        )

        XCTAssert(
            error: Map.Error.requiredEvenNumberOfValues,
            thrownBy: try Map(
                keyType: .string,
                valueType: .u8
            ) {
                String_("key0")
                U8(0)
                String_("key1")
            }
            
        )
    }
    
    func test_no_error_is_thrown_for_single_value_pairs() throws {
        
        XCTAssertNoThrow(try Map(
            keyType: .string,
            valueType: .u8
        ) {
            String_("key0")
            U8(0)
        })
    }
    
    
    func test_no_error_is_thrown_for_two_value_pairs() throws {
        
        XCTAssertNoThrow(try Map(
            keyType: .string,
            valueType: .u8
        ) {
            String_("key0")
            U8(0)
            String_("key1")
            U8(2)
        })
    }
    
    func test_error_is_thrown_for_incorrect_key_type_single_value_pair() throws {
        
        XCTAssert(
            error: Map.Error.unexpectedKeyTypeInKeyValuePairs,
            thrownBy: try Map(
                keyType: .string,
                valueType: .u8
            ) {
                I32(1337)
                U8(1)
            }
            
        )
    }
    
    func test_error_is_thrown_for_incorrect_value_type_single_value_pair() throws {
        
        XCTAssert(
            error: Map.Error.unexpectedValueTypeInKeyValuePairs,
            thrownBy: try Map(
                keyType: .string,
                valueType: .u8
            ) {
                String_("key0")
                I8(1)
            }
            
        )
    }
    
    func test_error_is_thrown_for_incorrect_key_type_two_value_pairs() throws {
        
        XCTAssert(
            error: Map.Error.unexpectedKeyTypeInKeyValuePairs,
            thrownBy: try Map(
                keyType: .string,
                valueType: .u8
            ) {
                String_("key0")
                U8(0)
                I32(1337)
                U8(1)
            }
        )
    }
    
    func test_error_is_thrown_for_incorrect_value_type_two_value_pairs() throws {
        
        XCTAssert(
            error: Map.Error.unexpectedValueTypeInKeyValuePairs,
            thrownBy: try Map(
                keyType: .string,
                valueType: .u8
            ) {
                String_("key0")
                U8(0)
                String_("key1")
                I8(1)
            }
        )
    }
}
