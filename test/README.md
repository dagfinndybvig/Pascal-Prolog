# Pascal-Prolog Test Suite

This directory contains comprehensive tests for the Pascal-Prolog compiler.

## Test Structure

### Functional Tests
These test cases verify that the compiler correctly handles various Pascal language features:

- **`test_basic_arithmetic.pas`**: Basic arithmetic operations (+, -)
- **`test_control_flow.pas`**: If-then-else statements
- **`test_while_loop.pas`**: While loop functionality
- **`test_string_output.pas`**: String literal output with `writeln`
- **`test_input_output.pas`**: Input/output operations with `readln` and `writeln`
- **`test_nested_blocks.pas`**: Nested block structures
- **`test_arithmetic_operations.pas`**: Multiplication (*) and division (/)
- **`test_relational_operators.pas`**: All relational operators (=, <>, <, <=, >, >=)
- **`test_unary_operations.pas`**: Unary minus operations
- **`test_complex_expression.pas`**: Complex nested expressions with parentheses

### Error Case Tests
These test cases verify that the compiler properly detects and reports errors:

- **`test_undeclared_variable.pas`**: Uses an undeclared variable
- **`test_duplicate_declaration.pas`**: Declares the same variable twice
- **`test_syntax_error.pas`**: Contains a syntax error (missing semicolon)

## Running the Tests

You can run the test suite from either the project root directory or from within the test directory:

From project root:
```bash
./test/run_tests.sh
```

From test directory:
```bash
./run_tests.sh
```

If you get an error about `pascal_compiler.pl` not being found, make sure you're running the script from one of these two locations.

The test runner will:
1. Compile each Pascal test program to a native executable
2. Run the executable and capture its output
3. Verify the output matches the expected results
4. Report pass/fail status for each test
5. Provide a summary of test results

## Test Results

All 13 tests should pass:
- 10 functional tests verifying correct compilation and execution
- 3 error case tests verifying proper error detection

Example successful output:

```
Running Pascal-Prolog test suite...
==================================
Testing test_basic_arithmetic...
  ✓ PASS
Testing test_control_flow...
  ✓ PASS
... (additional tests)
Testing test_undeclared_variable (should fail to compile)...
  ✓ PASS - Correctly failed to compile
==================================
Test Results:
  Passed: 13
  Failed: 0
==================================
All tests passed!
```

## Test Coverage

The test suite covers:
- ✅ Variable declarations and assignments
- ✅ Integer arithmetic (+, -, *, /)
- ✅ Control flow (if-then-else, while loops)
- ✅ I/O operations (readln, writeln)
- ✅ String literal output
- ✅ Nested block structures
- ✅ Relational operators
- ✅ Unary operations
- ✅ Complex expressions
- ✅ Error detection (undeclared variables, duplicate declarations, syntax errors)

## Adding New Tests

To add a new test:
1. Create a new `.pas` file in the `test/` directory
2. Add the test case to the `TEST_CASES` array in `run_tests.sh`
3. For functional tests, specify the expected output after a colon
4. For error tests, add to the `ERROR_CASES` array

Example:
```bash
TEST_CASES+=("test_new_feature:expected_output")
```