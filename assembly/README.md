# Assembly Backend Proof of Concept

This directory contains a minimal proof of concept (PoC) for the assembly backend of the Pascal-Prolog compiler. The goal is to demonstrate the feasibility of generating x86-64 assembly code from Pascal programs and building executables.

## Overview

The PoC implements a minimal assembly backend that can:
1. Generate x86-64 assembly code from a simple Pascal program.
2. Build an executable from the generated assembly.
3. Integrate with the existing compiler driver.

## Files

- `assembly.md`: Original assembly backend implementation plan.
- `plan.md`: Execution plan for implementing the assembly backend in an isolated directory.
- `PoC.md`: Minimal proof of concept plan.
- `src/codegen_asm_x86_64.pl`: Assembly code generator for x86-64.
- `test_hello.pas`: Simple Pascal program for testing.
- `README.md`: This file.

## How to Run

### Prerequisites

- SWI-Prolog
- GCC

### Running the Proof of Concept

1. **Generate Assembly**:
   ```bash
   swipl -q -s pascal_compiler.pl -- asm assembly/test_hello.pas assembly/hello.s
   ```

2. **Build Executable**:
   ```bash
   swipl -q -s pascal_compiler.pl -- build-asm assembly/test_hello.pas assembly/hello
   ```

3. **Run Executable**:
   ```bash
   ./assembly/hello
   ```

### Expected Output

```
Hello, World!
```

## Examples

### Example 1: Simple Hello World Program

**Input Pascal Program** (`test_hello.pas`):
```pascal
program Hello;
begin
  writeln('Hello, World!')
end.
```

**Generated Assembly** (`hello.s`):
```assembly
.data
msg:
	.asciz "Hello, World!\n"
.text
	.global main
main:
	pushq %rbp
	movq %rsp, %rbp
	leaq msg(%rip), %rdi
	call puts
	movq $0, %rax
	popq %rbp
	ret
```

**Expected Output**:
```
Hello, World!
```

## Testing

To test the assembly backend, follow these steps:

1. **Parse the Pascal Program**:
   ```bash
   swipl -q -s pascal_compiler.pl -- parse assembly/test_hello.pas
   ```

2. **Check the Pascal Program**:
   ```bash
   swipl -q -s pascal_compiler.pl -- check assembly/test_hello.pas
   ```

3. **Generate Assembly**:
   ```bash
   swipl -q -s pascal_compiler.pl -- asm assembly/test_hello.pas assembly/hello.s
   ```

4. **Build Executable**:
   ```bash
   swipl -q -s pascal_compiler.pl -- build-asm assembly/test_hello.pas assembly/hello
   ```

5. **Run Executable**:
   ```bash
   ./assembly/hello
   ```

## Success Criteria

1. The assembly backend can generate valid assembly for a simple Pascal program.
2. The generated assembly can be compiled and linked with the runtime.
3. The resulting executable runs correctly and produces the expected output.

## Notes

- This PoC focuses on demonstrating the basic workflow: Pascal → IR → Assembly → Executable.
- Advanced features (e.g., control flow, complex expressions) are not required for the PoC.
- The goal is to validate the feasibility of the assembly backend before investing in full implementation.

## Next Steps

1. Implement support for more Pascal constructs (e.g., variables, assignments, control flow).
2. Add support for arithmetic operations.
3. Implement proper register allocation.
4. Add support for function calls.
5. Implement stack frame management.
6. Add comprehensive testing.
