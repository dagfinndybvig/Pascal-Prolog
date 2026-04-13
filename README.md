# Pascal-Prolog

This project bootstraps a small Pascal compiler written in SWI-Prolog.

Current v1 subset:
- integer variables
- assignment
- `if` / `while`
- `writeln(expr)` and `readln(var)`

Compilation pipeline:
1. Lex/parse Pascal source to AST
2. Run semantic checks (declarations + variable usage)
3. Lower to a simple IR
4. Emit C
5. Compile with `gcc` and link a tiny runtime for I/O

## Requirements

- Linux environment
- SWI-Prolog (tested with `swipl`)
- GCC toolchain (compiler + linker)
- C standard library development headers (provided by `build-essential` on Debian/Ubuntu)

Ubuntu/Debian install:

```bash
sudo apt update
sudo apt install -y swi-prolog-nox build-essential
```

Quick dependency check:

```bash
swipl --version
gcc --version
```

## CLI usage

From this directory (`Pascal-Prolog/`):

```bash
swipl -q -s pascal_compiler.pl -- parse examples/hello.pas
swipl -q -s pascal_compiler.pl -- check examples/hello.pas
swipl -q -s pascal_compiler.pl -- c examples/hello.pas hello.c
swipl -q -s pascal_compiler.pl -- build examples/hello.pas hello
./hello
```

Expected output:

```text
42
```

For input/output example:

```bash
swipl -q -s pascal_compiler.pl -- build examples/sum_to_n.pas sum_to_n
printf '5\n' | ./sum_to_n
```

Expected output:

```text
15
```

## Notes

- Direct assembly generation is feasible, but this first backend targets C for faster correctness and easier runtime integration.
- The runtime is in `runtime/runtime.c` and is intentionally small so an assembly backend can reuse the same ABI later.
- Generated binaries are native Linux executables.

## Supported Pascal subset (v1)

- Program header: `program <name>;`
- Optional integer variable declarations in a `var` section
- Statements inside `begin ... end`
- Assignment: `x := expr`
- Control flow: `if ... then ... else ...`, `while ... do ...`
- I/O: `writeln(expr)`, `readln(variable)`
- Integer arithmetic: `+`, `-`, `*`, `/`
- Relational operators: `=`, `<>`, `<`, `<=`, `>`, `>=`

Not implemented yet: procedures/functions, arrays, records, strings, and direct assembly backend.
