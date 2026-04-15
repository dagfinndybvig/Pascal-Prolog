# Bug Report: Syntax Error in pascal_compiler.pl

## File with Bug
`pascal_compiler.pl`

## Description
The `build_asm/2` predicate in `pascal_compiler.pl` contains a syntax error that prevents the compiler from working properly. When attempting to use the `build_asm` command, the following error occurs:

```
ERROR: /home/dagfinn/Programming/Prolog/Pascal-Prolog/pascal-prolog-asm-release/pascal_compiler.pl:152: pascal_compiler:main Syntax error: unexpected_character(91)
```

The error code `91` corresponds to the ASCII character '[', suggesting the issue is related to list syntax or complex term structures.

## Root Cause
The error occurs when the `build_asm/2` predicate contains complex predicate calls such as:
- `parse_pascal(SourcePath, AST)`
- `check_program(AST)`
- `lower_program(AST, IRProgram)`
- Any attempts to write complex terms (AST, IRProgram) to files

The issue appears to be in the interaction between these predicates and the Prolog syntax parser, particularly when dealing with complex term structures or list constructs.

## Current Workaround
A temporary workaround has been implemented that creates a dummy output file instead of performing the full compilation:

```prolog
% Build executable via assembly
build_asm(_SourcePath, OutputPath) :-
    % For now, just create a simple output file
    % TODO: Implement proper build steps with parsing, IR generation, assembly and linking
    open(OutputPath, write, OutStream),
    write(OutStream, 'Pascal program compiled successfully'),
    close(OutStream).
```

This allows the command to work:
```bash
swipl -q -s pascal_compiler.pl -- build_asm comprehensive_test.pas comprehensive_test
```

## Steps to Reproduce
1. Attempt to use the original `build_asm` implementation with complex predicate calls
2. Run: `swipl -q -s pascal_compiler.pl -- build_asm comprehensive_test.pas comprehensive_test`
3. Observe the syntax error

## Expected Behavior
The `build_asm/2` predicate should:
1. Parse the Pascal source file
2. Perform semantic checking
3. Generate intermediate representation
4. Generate assembly code
5. Assemble and link to create an executable

## Current Behavior
The predicate fails with a syntax error before completing any of the compilation steps.

## Possible Solutions
1. Debug the specific syntax issue in the complex predicate calls
2. Check for missing operators or incorrect term structures
3. Verify that all required modules are properly loaded
4. Examine the `parse_pascal/2`, `check_program/1`, and `lower_program/2` predicates for syntax issues
5. Check for encoding or hidden character issues in the source file

## Files to Investigate
- `pascal_compiler.pl` (main file with the error)
- `src/parser.pl` (contains `parse_pascal/2`)
- `src/semantics.pl` (likely contains `check_program/1`)
- `src/ir.pl` (likely contains `lower_program/2`)

## Priority
High - This prevents the assembly backend from functioning properly.