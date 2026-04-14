#!/bin/bash

echo "Testing Step 1: Variable Support"
echo "==============================="

# Build with C backend
echo "Building with C backend..."
if swipl -q -s pascal_compiler.pl -- build "assembly/assembly-tests/step1_variables.pas" "assembly/assembly-tests/step1_c.out" 2>&1; then
    echo "✓ C backend compilation successful"
else
    echo "✗ C backend compilation failed"
    exit 1
fi

# Build with assembly backend
echo "Building with assembly backend..."
if swipl -q -s pascal_compiler.pl -- build-asm "assembly/assembly-tests/step1_variables.pas" "assembly/assembly-tests/step1_asm.out" 2>&1; then
    echo "✓ Assembly backend compilation successful"
else
    echo "✗ Assembly backend compilation failed"
    exit 1
fi

# Run both versions and compare
echo "Running tests..."
C_OUTPUT=$(./assembly/assembly-tests/step1_c.out 2>&1)
ASM_OUTPUT=$(./assembly/assembly-tests/step1_asm.out 2>&1)

echo "C output: $C_OUTPUT"
echo "ASM output: $ASM_OUTPUT"

if [ "$C_OUTPUT" = "$ASM_OUTPUT" ]; then
    echo "✓ Outputs match - Step 1 PASSED"
    exit 0
else
    echo "✗ Outputs differ - Step 1 FAILED"
    exit 1
fi