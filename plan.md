# Pascal-in-Prolog compiler plan

## Problem and approach
Build a Pascal parser and translator in SWI-Prolog, then compile generated output to a Linux executable in this environment.  
Use a staged compiler pipeline: **Lexer/Parser (DCG) -> Typed AST -> IR -> backend codegen -> gcc toolchain**.

## Current codebase state
- `Pascal-Prolog/` now contains a working v1 compiler scaffold:
  - `pascal_compiler.pl` CLI driver
  - `src/lexer.pl`, `src/parser.pl`, `src/semantics.pl`, `src/ir.pl`, `src/codegen_c.pl`
  - `runtime/runtime.c`, `runtime/runtime.h`
  - `examples/hello.pas`, `examples/sum_to_n.pas`
- `lambda-eval/` already demonstrates:
  - DCG-based parsing (`lambda_eval.pl`)
  - AST transformation and evaluation
  - CLI execution model with SWI-Prolog

## Feasibility decisions
- **Assembly + GCC is realistic**: emit AT&T/Intel assembly (`.s`) and use `gcc`/`as`/`ld` to produce binaries.
- For a first working compiler, **C as an intermediate target is lower risk** than direct assembly:
  - faster bring-up and debugging
  - easier ABI correctness
  - simpler I/O integration through libc
- Recommended roadmap: start with C backend for correctness, then add direct assembly backend once semantics stabilize.

## Runtime and I/O strategy
- Implement a tiny runtime shim (initially in C, later optionally in assembly) exposing:
  - integer output (`writeln` subset)
  - integer input (`readln` subset)
  - process exit
- Generated code calls runtime helpers; runtime maps to libc (`printf`, `scanf`, `putchar`, etc.).
- Keep runtime API language-agnostic so both C and assembly backends can reuse it.

## Implementation phases
1. **Language subset definition** ✅
   - Freeze a **minimal teaching subset** for v1: integers, variable declarations, assignment, `if`, `while`, `writeln`, `readln`.
   - Specify syntax and semantics in a short internal spec.
2. **Frontend** ✅
   - Build tokenizer and DCG parser for the subset.
   - Produce source-located AST nodes for diagnostics.
3. **Semantic analysis** ✅
   - Symbol table with lexical scopes.
   - Type checks for integers/booleans and assignment/procedure call rules.
4. **IR and lowering** ✅
   - Define a simple linear IR (labels, jumps, temps, calls).
   - Lower structured control flow (`if`, `while`, `for`) into IR.
5. **Backend v1 (C target)** ✅
   - Emit portable C from IR.
   - Compile with `gcc` to executable.
6. **Runtime library** ✅
   - Implement I/O/runtime helpers and link into builds.
7. **Tooling** ✅
   - CLI command: parse-only, type-check-only, compile.
   - Add sample programs and regression tests.
8. **Backend v2 (optional direct assembly)** ⏳
   - Emit x86-64 System V assembly from IR.
   - Keep runtime ABI stable and reuse runtime helpers.
   - Implementation outline:
     - Add `src/codegen_asm_x86_64.pl` with a deterministic mapping from IR nodes to textual assembly.
     - Define a stack-frame convention for generated functions (`main` only in v1): prologue/epilogue, local variable slots, and alignment to 16 bytes before calls.
     - Maintain a simple variable layout table (`Var -> [rbp-offset]`) and emit loads/stores with fixed-width integer ops.
     - Lower arithmetic/comparison IR to register-based sequences (`rax`, `rbx`, `rcx`, `rdx`) and materialize boolean results as `0/1`.
     - Emit labels and branch instructions for `if`/`while` using a monotonic label generator (`L_if_1_else`, `L_while_2_head`, etc.).
     - Implement calling convention for runtime helpers (`rt_writeln_int`, `rt_readln_int`) using SysV argument/return registers (`rdi`, `rax`).
     - Extend `pascal_compiler.pl` with `asm` and `build-asm` modes: write `.s`, then run `gcc <file.s> runtime/runtime.c -o <bin>`.
     - Add backend parity tests: compile the same examples with C backend and assembly backend, compare outputs for equality.
     - Add one diagnostic mode to dump IR + generated assembly side-by-side for debugging codegen mismatches.

## Initial deliverables
- `pascal_compiler.pl` (driver)
- `src/lexer.pl`, `src/parser.pl`
- `src/semantics.pl`, `src/ir.pl`
- `src/codegen_c.pl` (first backend)
- `runtime/runtime.c`, `runtime/runtime.h`
- `examples/hello.pas`, `examples/sum_to_n.pas`

## Current status
- End-to-end compile path is in place for the v1 subset: Pascal -> Prolog frontend/semantics/IR -> C -> GCC binary.
- Runtime I/O is wired (`readln` and `writeln` for integers).
- Optional assembly backend remains as a next step.

## Notes and constraints
- Favor explicit error reporting over permissive parsing.
- Keep grammar and semantic checks modular so adding features (arrays, records, procedures with params) is incremental.
- Direct assembly remains feasible, but is best treated as a second backend after frontend/semantics are validated.

## Final goal: compatibility with Wirth's *Algorithms + Data Structures = Programs*
- We ideally want this compiler to run a substantial share of the book's Pascal examples.

### What we have now
- Integer variables, arithmetic, relational operators.
- Assignment, `if`, `while`, `begin ... end`.
- Basic integer I/O via `readln` and `writeln`.
- End-to-end build path to native executable (Pascal -> C -> GCC).

### What we still need
1. Procedures/functions with parameters, lexical scope, and recursion.
2. Arrays and indexed access (for sorting and table-based examples).
3. Records and pointer-based dynamic structures (`new`/`dispose`) for lists/trees.
4. Broader control-flow support (`for`, `repeat ... until`, `case`).
5. Richer Pascal type support (booleans/enums/subranges and eventually sets/files as needed).
6. Better diagnostics and conformance tests against representative programs from each chapter.

### Practical compatibility assessment
- **Current:** suitable for only early/basic examples.
- **After items 1-4:** likely enough for many core algorithm/data-structure examples.
- **After items 5-6:** realistic path to broad book-level compatibility.
