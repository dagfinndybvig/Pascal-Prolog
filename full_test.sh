#!/bin/bash

# Full comprehensive test script for Pascal-Prolog assembly backend
# This script compiles and runs the comprehensive test program using the assembly backend

set -e  # Exit on any error

echo "=== Pascal-Prolog Comprehensive Test ==="
echo "Testing assembly backend with all implemented features"
echo

# Clean up any previous builds
rm -f comprehensive_test_asm comprehensive_test_c comprehensive_test.s comprehensive_test.c

# Compile with assembly backend
echo "1. Compiling with assembly backend..."
swipl -q -s pascal_compiler.pl -- build-asm comprehensive_test.pas comprehensive_test_asm
echo "   ✅ Assembly compilation successful"

# Run assembly version
echo "2. Running assembly version..."
echo "42" | ./comprehensive_test_asm
echo "   ✅ Assembly execution successful"

# Compile with C backend for comparison
echo "3. Compiling with C backend for comparison..."
swipl -q -s pascal_compiler.pl -- build comprehensive_test.pas comprehensive_test_c
echo "   ✅ C compilation successful"

# Run C version
echo "4. Running C version..."
echo "42" | ./comprehensive_test_c
echo "   ✅ C execution successful"

# Verify both produce identical output
echo "5. Verifying output consistency..."
ASM_OUTPUT=$(echo "42" | ./comprehensive_test_asm)
C_OUTPUT=$(echo "42" | ./comprehensive_test_c)

if [ "$ASM_OUTPUT" = "$C_OUTPUT" ]; then
    echo "   ✅ Both backends produce identical output"
    echo
    echo "Expected output:"
    echo "$ASM_OUTPUT"
else
    echo "   ❌ Output mismatch detected!"
    echo "Assembly output:"
    echo "$ASM_OUTPUT"
    echo "C output:"
    echo "$C_OUTPUT"
    exit 1
fi

echo
echo "=== All tests passed successfully! ==="
echo "The assembly backend is working correctly with all implemented features:"
echo "  • Variable declarations and assignments"
echo "  • Basic arithmetic operations (+, *, /)"
echo "  • Complex nested expressions"
echo "  • Unary operations (negative numbers)"
echo "  • Relational operators and conditionals"
echo "  • Nested blocks with local variables"
echo "  • While loops with compound statements"
echo "  • String literal output"
echo "  • Input operations (readln)"
echo "  • Multiple writeln statements"