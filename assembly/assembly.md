# Assembly Backend Implementation Plan

## Overview
This document outlines the plan for adding an x86-64 assembly backend to the Pascal-Prolog compiler. The assembly backend will complement the existing C backend, providing direct compilation to native code.

## Goals
1. Generate x86-64 assembly code from the existing IR
2. Maintain compatibility with the current runtime ABI
3. Support all features currently handled by the C backend
4. Provide comparable performance to the C backend

## Implementation Phases

### Phase 1: Infrastructure Setup
- Create `src/codegen_asm_x86_64.pl` module
- Add assembly-specific predicates and data structures
- Integrate with main compiler driver (`pascal_compiler.pl`)
- Add new CLI commands: `asm` and `build-asm`

### Phase 2: Basic Code Generation
- Implement IR to assembly mapping for simple statements:
  - Variable declarations
  - Assignments
  - Basic arithmetic operations
- Generate proper prologue and epilogue for `main` function
- Implement basic register allocation strategy

### Phase 3: Control Flow
- Implement label generation system
- Handle `if` statements with conditional jumps
- Implement `while` loops with proper entry/exit labels
- Ensure correct stack alignment before calls

### Phase 4: Expression Handling
- Complete arithmetic operation implementation
- Handle all binary operators (+, -, *, /)
- Implement unary operations
- Ensure proper register usage and spilling

### Phase 5: Runtime Integration
- Generate calls to runtime functions:
  - `rt_readln_int`
  - `rt_writeln_int`
  - `rt_writeln_str`
  - `rt_write_int`
  - `rt_write_str`
- Follow System V AMD64 ABI for function calls
- Maintain compatibility with existing runtime ABI

### Phase 6: Advanced Features
- Implement proper stack frame management
- Handle nested blocks and scopes
- Optimize register usage
- Add support for more complex expressions

### Phase 7: Testing and Validation
- Create assembly-specific test cases
- Add backend parity tests (compare C and assembly outputs)
- Implement diagnostic mode for IR/assembly comparison
- Debug and fix issues

## Technical Details

### Target Architecture
- x86-64 (AMD64) architecture
- System V ABI calling convention
- AT&T assembly syntax

### Register Usage
- `rax`: Return values, temporary calculations
- `rbx`, `rcx`, `rdx`: Temporary registers
- `rsi`, `rdi`: Argument passing
- `rbp`: Base pointer (optional, depending on frame strategy)
- `rsp`: Stack pointer

### Stack Frame
- 16-byte alignment before calls
- Local variables stored at negative offsets from `rbp`
- Simple variable layout table: `Var -> [rbp-offset]`

### Label Generation
- Monotonic label counter
- Pattern: `L_<type>_<id>`
- Examples: `L_if_1_else`, `L_while_2_head`, `L_while_2_exit`

### Assembly Generation Strategy
1. Lower Pascal to IR (existing)
2. Analyze IR for register pressure
3. Allocate registers for variables
4. Generate assembly for each IR statement
5. Handle control flow with labels and jumps
6. Generate function prologue and epilogue
7. Emit assembly to `.s` file

## Integration with Build System

### New CLI Commands
```bash
# Generate assembly only
swipl -q -s pascal_compiler.pl -- asm <source.pas> <out.s>

# Build executable via assembly
swipl -q -s pascal_compiler.pl -- build-asm <source.pas> <out_binary>
```

### Build Process
1. Parse Pascal source
2. Run semantic checks
3. Lower to IR
4. Generate assembly
5. Compile with GCC: `gcc <file.s> runtime/runtime.c -o <bin>`

## Testing Strategy

### Test Coverage
- All existing functional tests should pass
- Assembly output should match C output for same inputs
- Performance should be comparable to C backend

### Test Types
1. **Functional Tests**: Verify correct execution
2. **Parity Tests**: Compare assembly and C outputs
3. **Performance Tests**: Measure execution time
4. **Edge Case Tests**: Complex expressions, nested control flow

## Timeline Estimate
- **Phase 1-2**: 3-5 days
- **Phase 3-4**: 4-6 days
- **Phase 5-6**: 3-4 days
- **Phase 7**: 3-5 days
- **Total**: 2-3 weeks (calendar time may vary)

## Dependencies
- Existing IR structure (stable)
- Current runtime ABI (stable)
- GCC toolchain (for assembly and linking)
- SWI-Prolog (existing)

## Risks and Mitigations
- **Register allocation complexity**: Start with simple strategy, optimize later
- **Debugging assembly**: Implement good diagnostic output early
- **ABI compatibility**: Reuse existing runtime functions unchanged
- **Performance issues**: Profile and optimize critical paths

## Success Criteria
1. All existing test cases pass with assembly backend
2. Assembly output is correct and executable
3. Performance is comparable to C backend
4. Code is well-documented and maintainable
5. Build process is reliable and integrated with existing workflow