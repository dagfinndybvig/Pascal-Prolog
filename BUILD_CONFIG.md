# Build Configuration and Dependencies

## System Requirements

### Required Dependencies
- **SWI-Prolog** 8.4.2+ (tested with 8.4.2)
- **GCC** 11.4.0+ (tested with 11.4.0)
- **GNU Make** (for build scripts)
- **Bash** (for test scripts)

### Ubuntu/Debian Installation
```bash
sudo apt update
sudo apt install -y swi-prolog-nox build-essential
```

### Verification
```bash
swipl --version  # Should show SWI-Prolog version 8.4.2+
gcc --version    # Should show gcc version 11.4.0+
```

## Build Configuration

### Compiler Backends
1. **C Backend** (original)
   - Generates C code from Pascal
   - Compiles with GCC and links with runtime
   - Command: `swipl -q -s pascal_compiler.pl -- build <source.pas> <output>`

2. **Assembly Backend** (new)
   - Generates x86-64 assembly directly
   - Compiles with GCC and links with runtime
   - Command: `swipl -q -s pascal_compiler.pl -- build-asm <source.pas> <output>`

### Runtime Components
- `runtime/runtime.c`: Core runtime functions
- `runtime/runtime.h`: Runtime function declarations
- `runtime/libruntime.a`: Pre-compiled runtime library

### Runtime Functions
```c
int rt_readln_int(void);          // Read integer from stdin
void rt_writeln_int(int value);   // Write integer to stdout with newline
void rt_writeln_str(const char *value); // Write string to stdout with newline
void rt_write_int(int value);      // Write integer to stdout (no newline)
void rt_write_str(const char *value);   // Write string to stdout (no newline)
void rt_error(int code, const char *message); // Error handling
```

### Error Codes
```c
#define RT_ERROR_STACK_OVERFLOW 1
#define RT_ERROR_DIVISION_BY_ZERO 2
#define RT_ERROR_ARRAY_BOUNDS 3
#define RT_ERROR_NULL_POINTER 4
#define RT_ERROR_INVALID_OPERATION 5
```

## Build Process

### Assembly Backend Build Steps
1. Parse Pascal source → AST
2. Semantic analysis → IR
3. IR → x86-64 assembly
4. GCC compiles assembly + runtime → executable

### Build Commands
```bash
# Parse only
swipl -q -s pascal_compiler.pl -- parse <source.pas>

# Check semantics
swipl -q -s pascal_compiler.pl -- check <source.pas>

# Generate assembly only
swipl -q -s pascal_compiler.pl -- asm <source.pas> <output.s>

# Build executable via assembly backend
swipl -q -s pascal_compiler.pl -- build-asm <source.pas> <output>

# Build executable via C backend
swipl -q -s pascal_compiler.pl -- build <source.pas> <output>
```

## Test Configuration

### Test Suites
1. **Main Test Suite** (`test/`)
   - 10 functional tests
   - 3 error case tests
   - Run: `./test/run_tests.sh`

2. **Assembly Backend Tests** (`assembly/assembly-tests/`)
   - 5 expansion steps (variables, arithmetic, control flow, I/O, advanced)
   - 2 regression tests
   - Run: `./assembly/assembly-tests/test_all_steps.sh`

3. **Edge Case Tests** (new)
   - Arithmetic edge cases
   - Control flow edge cases
   - Nested blocks and scoping
   - Error conditions

### Test Coverage
- ✅ Variables and assignments
- ✅ Arithmetic operations (+, -, *, /)
- ✅ Control flow (if-else, while loops)
- ✅ Nested blocks and scoping
- ✅ I/O operations (readln, write, writeln)
- ✅ String literals
- ✅ Error handling (stack overflow, division by zero)
- ✅ Edge cases (large numbers, complex expressions)

## Build Verification

### Quick Smoke Test
```bash
# Test assembly backend
swipl -q -s pascal_compiler.pl -- build-asm assembly/test_hello.pas test_asm
./test_asm  # Should output "Hello, World!"

# Test C backend
swipl -q -s pascal_compiler.pl -- build examples/hello.pas test_c
./test_c  # Should output "Hello, the answer is: 42"
```

### Comprehensive Test
```bash
# Run all assembly backend tests
./assembly/assembly-tests/test_all_steps.sh

# Run all main tests
./test/run_tests.sh
```

## Project Structure

```
Pascal-Prolog/
├── pascal_compiler.pl          # Main compiler entry point
├── src/                        # Compiler source (Prolog)
│   ├── parser.pl               # Pascal parser
│   ├── semantics.pl           # Semantic analysis
│   ├── ir.pl                  # Intermediate representation
│   ├── codegen_c.pl           # C code generator
│   └── codegen_asm_x86_64.pl  # Assembly code generator (NEW)
├── runtime/                    # Runtime library
│   ├── runtime.c              # Runtime functions
│   ├── runtime.h              # Runtime headers
│   ├── runtime.o              # Compiled runtime
│   └── libruntime.a           # Runtime archive
├── assembly/                   # Assembly backend (NEW)
│   ├── src/                   # Assembly-specific code
│   ├── assembly-tests/        # Assembly backend tests
│   └── test_*.pas              # Test programs
├── examples/                   # Example Pascal programs
├── test/                       # Main test suite
└── README.md                   # Main documentation
```

## Configuration Summary

### Supported Features
- ✅ Integer variables and assignments
- ✅ Arithmetic operations (+, -, *, /)
- ✅ Control flow (if-else, while)
- ✅ I/O operations (readln, write, writeln)
- ✅ String literals (output only)
- ✅ Nested blocks with local variables
- ✅ Stack overflow protection
- ✅ Division by zero detection
- ✅ Register allocation optimization
- ✅ Comprehensive error handling

### Limitations
- ❌ No string variables or string expressions
- ❌ No arrays or records
- ❌ No procedures or functions
- ❌ No floating-point support
- ❌ No pointer arithmetic

### Performance Characteristics
- **Stack Usage**: Dynamic sizing with overflow protection
- **Register Usage**: Optimized allocation for expressions
- **Error Handling**: Runtime detection with clear messages
- **Compatibility**: Full parity between C and assembly backends

## Troubleshooting

### Common Issues

1. **Missing dependencies**:
   ```bash
   sudo apt install swi-prolog-nox build-essential
   ```

2. **Locale warnings**:
   ```bash
   export LC_ALL=C
   ```

3. **Permission issues**:
   ```bash
   chmod +x *.sh
   ```

4. **Test failures**:
   ```bash
   ./test/run_tests.sh -v  # Verbose mode
   ```

### Debugging

```bash
# Check assembly generation
swipl -q -s pascal_compiler.pl -- asm test.pas test.s

# Inspect generated assembly
cat test.s

# Manual compilation
gcc -std=c11 -Wall -Wextra test.s runtime/runtime.c -o test_manual
```

## Build Status

✅ **All dependencies installed and verified**
✅ **Both backends (C and Assembly) working**
✅ **All test suites passing**
✅ **Edge case tests added and working**
✅ **Error handling implemented and tested**
✅ **Documentation updated**

The project is fully functional with comprehensive test coverage and proper dependency management.