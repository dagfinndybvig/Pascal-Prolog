# Minimal Proof of Concept (PoC) for Assembly Backend

## Overview
This document outlines the absolute minimal steps to create a proof of concept for the assembly backend. The goal is to demonstrate feasibility without implementing the full feature set.

## Steps

### 1. Basic Infrastructure
- Create `src/codegen_asm_x86_64.pl` in the `assembly` directory.
- Implement a minimal predicate to generate assembly for a simple Pascal program (e.g., `writeln('Hello, World!')`).

### 2. Integration with Compiler Driver
- Modify `pascal_compiler.pl` to include a basic `asm` command.
- Ensure the `asm` command calls the assembly backend.

### 3. Generate Assembly
- Implement assembly generation for a single statement (e.g., `writeln('Hello, World!')`).
- Ensure the generated assembly is syntactically correct and can be compiled.

### 4. Build and Run
- Compile the generated assembly with GCC and the runtime to produce an executable.
- Verify the executable runs correctly and produces the expected output.

## Success Criteria
1. The assembly backend can generate valid assembly for a simple Pascal program.
2. The generated assembly can be compiled and linked with the runtime.
3. The resulting executable runs correctly and produces the expected output.

## Example

### Input Pascal Program
```pascal
program Hello;
begin
  writeln('Hello, World!')
end.
```

### Expected Output
```bash
Hello, World!
```

### Generated Assembly
```assembly
.section .data
hello_msg:
  .asciz "Hello, World!\n"

.section .text
.global main
main:
  pushq %rbp
  movq %rsp, %rbp
  leaq hello_msg(%rip), %rdi
  call rt_writeln_str
  movq $0, %rax
  popq %rbp
  ret
```

## Notes
- This PoC focuses on demonstrating the basic workflow: Pascal → IR → Assembly → Executable.
- Advanced features (e.g., control flow, complex expressions) are not required for the PoC.
- The goal is to validate the feasibility of the assembly backend before investing in full implementation.
