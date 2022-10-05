#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

char *__transaction_lib_alloc(uintptr_t capacity);

void __transaction_lib_free(char *pointer);

const char *information(const char *string_pointer);

const char *convert_manifest(const char *string_pointer);

const char *compile_transaction_intent(const char *string_pointer);

const char *decompile_transaction_intent(const char *string_pointer);

const char *compile_signed_transaction_intent(const char *string_pointer);

const char *decompile_signed_transaction_intent(const char *string_pointer);

const char *compile_notarized_transaction_intent(const char *string_pointer);

const char *decompile_notarized_transaction_intent(const char *string_pointer);

const char *decompile_unknown_transaction_intent(const char *string_pointer);

const char *decode_address(const char *string_pointer);

const char *encode_address(const char *string_pointer);

const char *sbor_decode(const char *string_pointer);

const char *sbor_encode(const char *string_pointer);

const char *extract_abi(const char *string_pointer);

const char *derive_non_fungible_address_from_public_key(const char *string_pointer);

const char *derive_non_fungible_address(const char *string_pointer);
