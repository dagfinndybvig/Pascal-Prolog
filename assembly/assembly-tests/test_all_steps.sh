#!/bin/bash

# Test script for assembly backend expansion steps

PROJECT_ROOT="."
ASSEMBLY_TESTS="assembly/assembly-tests"

# Test each step
echo "Testing Assembly Backend Expansion Steps"
echo "=========================================="

for STEP in 1 2 3 4 5; do
    echo ""
    echo "Step $STEP:"

    case "$STEP" in
        1) STEP_SOURCE="step1_variables.pas" ;;
        2) STEP_SOURCE="step2_arithmetic.pas" ;;
        3) STEP_SOURCE="step3_control_flow.pas" ;;
        4) STEP_SOURCE="step4_io_operations.pas" ;;
        5) STEP_SOURCE="step5_advanced.pas" ;;
    esac
    
    # Build with C backend
    if swipl -q -s pascal_compiler.pl -- build "$ASSEMBLY_TESTS/$STEP_SOURCE" "$ASSEMBLY_TESTS/step${STEP}_c.out" 2>&1; then
        echo "  ✓ C backend compilation successful"
    else
        echo "  ✗ C backend compilation failed"
        continue
    fi
    
    # Build with assembly backend
    if swipl -q -s pascal_compiler.pl -- build-asm "$ASSEMBLY_TESTS/$STEP_SOURCE" "$ASSEMBLY_TESTS/step${STEP}_asm.out" 2>&1; then
        echo "  ✓ Assembly backend compilation successful"
    else
        echo "  ✗ Assembly backend compilation failed"
        continue
    fi
    
    # Run both versions and compare
    if [ "$STEP" -eq 4 ]; then
        TEST_INPUT=$'3\n4\n'
        C_OUTPUT=$(printf "%s" "$TEST_INPUT" | "./$ASSEMBLY_TESTS/step${STEP}_c.out" 2>&1)
        ASM_OUTPUT=$(printf "%s" "$TEST_INPUT" | "./$ASSEMBLY_TESTS/step${STEP}_asm.out" 2>&1)
    else
        C_OUTPUT=$("./$ASSEMBLY_TESTS/step${STEP}_c.out" 2>&1)
        ASM_OUTPUT=$("./$ASSEMBLY_TESTS/step${STEP}_asm.out" 2>&1)
    fi
    
    if [ "$C_OUTPUT" = "$ASM_OUTPUT" ]; then
        echo "  ✓ Outputs match"
    else
        echo "  ✗ Outputs differ"
        echo "  C output: $C_OUTPUT"
        echo "  ASM output: $ASM_OUTPUT"
    fi
    
    # Clean up
    rm -f "$ASSEMBLY_TESTS/step${STEP}_c.out" "$ASSEMBLY_TESTS/step${STEP}_asm.out"
done

echo ""
echo "String output regression case:"
if swipl -q -s pascal_compiler.pl -- build "assembly/assembly-tests/string_output_robustness.pas" "assembly/assembly-tests/string_output_robustness_c.out" 2>&1 &&
   swipl -q -s pascal_compiler.pl -- build-asm "assembly/assembly-tests/string_output_robustness.pas" "assembly/assembly-tests/string_output_robustness_asm.out" 2>&1; then
    C_OUTPUT=$(./assembly/assembly-tests/string_output_robustness_c.out 2>&1)
    ASM_OUTPUT=$(./assembly/assembly-tests/string_output_robustness_asm.out 2>&1)
    if [ "$C_OUTPUT" = "$ASM_OUTPUT" ]; then
        echo "  ✓ string_output_robustness outputs match"
    else
        echo "  ✗ string_output_robustness outputs differ"
        echo "  C output: $C_OUTPUT"
        echo "  ASM output: $ASM_OUTPUT"
    fi
else
    echo "  ✗ string_output_robustness compilation failed"
fi

echo ""
echo "Minimal regression case:"
if swipl -q -s pascal_compiler.pl -- build "assembly/assembly-tests/minimal_bug.pas" "assembly/assembly-tests/minimal_bug_c.out" 2>&1 &&
   swipl -q -s pascal_compiler.pl -- build-asm "assembly/assembly-tests/minimal_bug.pas" "assembly/assembly-tests/minimal_bug_asm.out" 2>&1; then
    C_OUTPUT=$(./assembly/assembly-tests/minimal_bug_c.out 2>&1)
    ASM_OUTPUT=$(./assembly/assembly-tests/minimal_bug_asm.out 2>&1)
    if [ "$C_OUTPUT" = "$ASM_OUTPUT" ]; then
        echo "  ✓ minimal_bug outputs match"
    else
        echo "  ✗ minimal_bug outputs differ"
        echo "  C output: $C_OUTPUT"
        echo "  ASM output: $ASM_OUTPUT"
    fi
else
    echo "  ✗ minimal_bug compilation failed"
fi

echo ""
echo "Testing complete"
