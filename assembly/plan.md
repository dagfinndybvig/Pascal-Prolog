# Execution Plan for Assembly Backend in Isolated Directory

## Overview
This document outlines how to execute the assembly backend plan wholly within the `assembly` directory without breaking the rest of the project.

## Steps

### 1. Isolate the Assembly Backend
- Create a separate module for the assembly backend in the `assembly` directory.
- Ensure the assembly backend is independent of the existing C backend.

### 2. Update the Compiler Driver
- Modify `pascal_compiler.pl` to include the assembly backend as an optional feature.
- Add new CLI commands (`asm` and `build-asm`) to the compiler driver.

### 3. Implement the Assembly Backend
- Create `src/codegen_asm_x86_64.pl` in the `assembly` directory.
- Implement the assembly-specific predicates and data structures.

### 4. Integrate with the Build System
- Update the build system to include the assembly backend as an optional target.
- Ensure the assembly backend can be built and tested independently.

### 5. Testing
- Create assembly-specific test cases in the `assembly` directory.
- Add backend parity tests to compare C and assembly outputs.

### 6. Documentation
- Update the project documentation to include the assembly backend.
- Ensure the assembly backend is well-documented and maintainable.

## Key Considerations
- **Independence**: The assembly backend should not interfere with the existing C backend.
- **Modularity**: Ensure the assembly backend can be built and tested independently.
- **Compatibility**: Maintain compatibility with the existing runtime ABI.
- **Documentation**: Keep the assembly backend well-documented for future maintenance.

## Success Criteria
1. The assembly backend is fully functional and can be built independently.
2. All existing test cases pass with the assembly backend.
3. The assembly backend does not break the existing C backend.
4. The assembly backend is well-documented and maintainable.
