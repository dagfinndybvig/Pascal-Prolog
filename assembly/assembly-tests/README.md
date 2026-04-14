# Assembly Backend Test Suite

This directory contains test programs for each expansion step of the assembly backend.

## Test Structure

Each test file corresponds to a specific expansion step:

- **step1_variables.pas**: Tests variable support (Step 1)
- **step2_arithmetic.pas**: Tests arithmetic operations (Step 2)
- **step3_control_flow.pas**: Tests control flow (Step 3)
- **step4_io_operations.pas**: Tests I/O operations (Step 4)
- **step5_advanced.pas**: Tests advanced features (Step 5)

## Testing Procedure

For each step:

1. **Build the test with C backend** (baseline):
   ```bash
   swipl -q -s pascal_compiler.pl -- build assembly/assembly-tests/stepX_test.pas assembly/assembly-tests/stepX_c.out
   ```

2. **Build the test with assembly backend**:
   ```bash
   swipl -q -s pascal_compiler.pl -- build-asm assembly/assembly-tests/stepX_test.pas assembly/assembly-tests/stepX_asm.out
   ```

3. **Compare outputs**:
   ```bash
   ./assembly/assembly-tests/stepX_c.out > c_output.txt
   ./assembly/assembly-tests/stepX_asm.out > asm_output.txt
   diff c_output.txt asm_output.txt
   ```

## Success Criteria

A step is considered complete when:
1. The assembly backend successfully compiles the test program
2. The assembly output matches the C backend output exactly
3. No runtime errors occur during execution

## Expected Outputs

### Step 1 (Variables)
```
30
```

### Step 2 (Arithmetic)
```
20
4
200
```

### Step 3 (Control Flow)
```
20
10
9
8
7
6
5
4
3
2
1
```

### Step 4 (I/O Operations)
```
Enter first number: Sum: 15
Product: 50
```

### Step 5 (Advanced)
```
15
-10
Success
x is >= 5
```