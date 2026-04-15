# Simple Performance Comparison

This demonstrates the performance difference using minimal, working programs.

## Programs

### Slow Version (`primes_simple_slow.pas`)
- Naive subtraction-based approach
- Tests all numbers from 2 to n-1
- No optimizations
- Complexity: O(n²)

### Fast Version (`primes_simple_fast.pas`)
- Square root optimization
- Skips even numbers
- Uses division
- Complexity: O(n√n)

## Build and Run

```bash
# Build both
swipl -q -s pascal_compiler.pl -- build-asm primes_simple_slow.pas primes_simple_slow
swipl -q -s pascal_compiler.pl -- build-asm primes_simple_fast.pas primes_simple_fast

# Run with timing
time ./primes_simple_slow  # Result: 168
time ./primes_simple_fast  # Result: 168
```

## Results

Both programs correctly find **168 primes under 1000**.

### Performance Comparison

| Version | Time | Complexity | Approach |
|---------|------|------------|----------|
| Slow | ~0.001s | O(n²) | Naive subtraction |
| Fast | ~0.001s | O(n√n) | Optimized division |

**Note**: At this small scale (n=1000), both complete too quickly to show dramatic timing differences. For larger ranges (n=10,000+), the fast version would be significantly faster.

## Key Insights

1. **Both are correct**: Same mathematical results
2. **Different approaches**: Subtraction vs division
3. **Optimization matters**: Fast version scales much better
4. **Small scale limitation**: Need larger ranges to see big differences

## For Larger Differences

To see dramatic performance differences, test with larger ranges:

```bash
# Modify programs to test up to 10,000 or 50,000
# Change: while i <= 10000 do
# Rebuild and compare timing
```

At larger scales, the O(n²) vs O(n√n) difference becomes clearly visible.