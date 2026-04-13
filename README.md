<img width="688" height="970" alt="image" src="https://github.com/user-attachments/assets/7a41845d-e6cb-4bc1-8c44-224f0755d6ff" />

# Pascal-Prolog

This project bootstraps a small Pascal compiler written in SWI-Prolog.

## Historical and pedagogical context

Pascal was designed by **Niklaus Wirth** in the early 1970s as a language for clear, structured programming and computer science education. It became one of the most influential teaching languages because its syntax and type discipline make algorithms and data structures explicit and readable.

This project is directly inspired by Wirth's classic book **_Algorithms + Data Structures = Programs_ (1976)**, where Pascal is used to teach the deep connection between problem-solving methods and data representation. Building a Pascal compiler in Prolog is both a historical exercise and a practical learning tool: it lets us study language implementation while reconnecting with a foundational pedagogical tradition in computer science.

Current v1 subset:
- integer variables
- assignment
- `if` / `while`
- `writeln(expr)`, `writeln('string literal')`, and `readln(var)`
- **restriction:** string support is output-only literals in `writeln`; no string variables, string types, or string expressions

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

What each command does:
- `parse`: parse Pascal source and print AST.
- `check`: parse + semantic checks (declarations/usage); prints `ok` on success.
- `c`: compile to generated C source only.
- `build`: full pipeline to native executable (includes runtime compilation/linking).
- `./hello`: run the produced executable.

Flag notes:
- `-q`: quiet SWI-Prolog startup output.
- `-s pascal_compiler.pl`: load the compiler entry script.
- `--`: separate SWI-Prolog flags from compiler command arguments.

Expected output:

```text
The answer is:
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

Quick smoke test script:

```bash
./test_hello.sh
```

This compiles `examples/hello.pas`, runs it, and prints:

```text
The answer is:
42
```

## Runtime build behavior

- No separate runtime setup/build step is required.
- `swipl -q -s pascal_compiler.pl -- build <source.pas> <out_binary>` automatically compiles and links:
  - generated C for your Pascal program
  - `runtime/runtime.c`
- If you use `-- c` (C emission only), you must compile manually and include `runtime/runtime.c`.

## Testing

A comprehensive test suite is available in the `test/` directory with:
- 10 functional tests covering all major Pascal features
- 3 error case tests for proper error detection
- Robust test runner script that works from both project root and test directory

Run all tests:
```bash
./test/run_tests.sh
```

See `test/README.md` for detailed test coverage and instructions for adding new tests.

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
- String literal output: `writeln('...')` (literals only, no string variables)
- Integer arithmetic: `+`, `-`, `*`, `/`
- Relational operators: `=`, `<>`, `<`, `<=`, `>`, `>=`

Not implemented yet: procedures/functions, arrays, records, string variables/types/expressions, and direct assembly backend.

## License

Released under the **Unlicense** (public domain dedication). See `UNLICENSE`.
