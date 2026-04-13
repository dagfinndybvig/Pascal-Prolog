#!/bin/bash

# Test script for Pascal-Prolog compiler

# Check if we're in the test directory and move to project root if needed
if [ -f "pascal_compiler.pl" ]; then
    # Already in project root
    PROJECT_ROOT="."
elif [ -f "../pascal_compiler.pl" ]; then
    # In test directory, move to project root
    cd ..
    PROJECT_ROOT="."
else
    echo "Error: Could not find pascal_compiler.pl"
    echo "This script must be run from either the project root directory or the test directory."
    exit 1
fi

echo "Running Pascal-Prolog test suite..."
echo "=================================="

# Test files and expected outputs
TEST_CASES=(
    "test_basic_arithmetic:8"
    "test_control_flow:1"
    "test_while_loop:15"
    "test_string_output:Hello, World!|This is a test."
    "test_input_output:Enter a number:|You entered:|42"
    "test_nested_blocks:3"
    "test_arithmetic_operations:30|3"
    "test_relational_operators:3"
    "test_unary_operations:-5|5"
    "test_complex_expression:5"
)

# Error case tests (should fail to compile)
ERROR_CASES=(
    "test_undeclared_variable"
    "test_duplicate_declaration"
    "test_syntax_error"
)

PASS_COUNT=0
FAIL_COUNT=0

# Test functional cases
for TEST_CASE in "${TEST_CASES[@]}"; do
    IFS=':' read -r TEST_NAME EXPECTED <<< "$TEST_CASE"
    
    echo "Testing $TEST_NAME..."
    
    # Compile the test
    if ! swipl -q -s pascal_compiler.pl -- build "test/$TEST_NAME.pas" "test/$TEST_NAME.out" 2>&1; then
        echo "  ✗ FAIL - Compilation failed"
        ((FAIL_COUNT++))
        continue
    fi
    
    # Run the test
    if [ "$TEST_NAME" = "test_input_output" ]; then
        OUTPUT=$(echo "42" | ./test/$TEST_NAME.out 2>&1)
    else
        OUTPUT=$(./test/$TEST_NAME.out 2>&1)
    fi
    
    # Check if output matches expected
    IFS='|' read -ra EXPECTED_PARTS <<< "$EXPECTED"
    ALL_MATCH=true
    for PART in "${EXPECTED_PARTS[@]}"; do
        if [[ "$OUTPUT" != *"$PART"* ]]; then
            ALL_MATCH=false
            break
        fi
    done
    
    if [ "$ALL_MATCH" = true ]; then
        echo "  ✓ PASS"
        ((PASS_COUNT++))
    else
        echo "  ✗ FAIL"
        echo "  Expected: $EXPECTED"
        echo "  Got: $OUTPUT"
        ((FAIL_COUNT++))
    fi
    
    # Clean up
    rm -f test/$TEST_NAME.out
    
    echo ""
done

# Test error cases (should fail to compile)
for ERROR_CASE in "${ERROR_CASES[@]}"; do
    echo "Testing $ERROR_CASE (should fail to compile)..."
    
    # Try to compile - this should fail
    if swipl -q -s pascal_compiler.pl -- build "test/$ERROR_CASE.pas" "test/$ERROR_CASE.out" 2>&1; then
        echo "  ✗ FAIL - Should have failed to compile"
        rm -f test/$ERROR_CASE.out
        ((FAIL_COUNT++))
    else
        echo "  ✓ PASS - Correctly failed to compile"
        ((PASS_COUNT++))
    fi
    
    echo ""
done

echo "=================================="
echo "Test Results:"
echo "  Passed: $PASS_COUNT"
echo "  Failed: $FAIL_COUNT"
echo "=================================="

if [ $FAIL_COUNT -eq 0 ]; then
    echo "All tests passed!"
    exit 0
else
    echo "Some tests failed."
    exit 1
fi