# Full Range Performance Comparison (2 to 46,225)

This document demonstrates the dramatic performance difference between the slowest and fastest prime algorithms when testing the full safe range.

## The Challenge

Find all prime numbers from 2 to 46,225 (the maximum safe limit before overflow).

## The Contenders

### 🐢 SLOW: `primes_slow_full.pas`
```bash
swipl -q -s pascal_compiler.pl -- build-asm primes_slow_full.pas primes_slow_full
./primes_slow_full
```

**Characteristics:**
- Tests ALL numbers from 2 to n-1 for each candidate
- Uses repeated subtraction (no division operations)
- No mathematical optimizations
- Complexity: O(n²) - quadratic time

**Expected Performance:**
- **Time**: Minutes to hours (depending on hardware)
- **Operations**: Billions of subtractions
- **Progress**: Slow, with progress dots every 1000 numbers

### 🚀 FAST: `primes_fast_full.pas`
```bash
swipl -q -s pascal_compiler.pl -- build-asm primes_fast_full.pas primes_fast_full
./primes_fast_full
```

**Characteristics:**
- Tests only up to √n
- Skips even numbers after testing 2
- Uses efficient division
- Complexity: O(n√n) - sub-quadratic time

**Expected Performance:**
- **Time**: Seconds
- **Operations**: Millions of operations
- **Progress**: Fast, with progress dots every 1000 numbers

## Expected Results

| Metric | Slow Version | Fast Version | Ratio |
|--------|--------------|--------------|-------|
| **Time** | Minutes-hours | Seconds | 100-1000× |
| **Operations** | ~1 billion | ~10 million | 100× |
| **Primes found** | 4,792 | 4,792 | Same |
| **Progress** | Slow dots | Fast dots | Visible |

## Mathematical Equivalence

Both algorithms implement the same prime test:
```
A number p is prime if it has no divisors other than 1 and p
```

**Slow version**: Checks every number from 2 to p-1 using subtraction
**Fast version**: Checks only odd numbers from 3 to √p using division

## Why the Difference Matters

### For n = 46,225:

**Slow approach operations:**
- For each number p, test p-2 divisors
- Average ~23,000 tests per number
- Total ~1 billion operations

**Fast approach operations:**
- For each number p, test √p/2 divisors (only odds)
- Average ~100 tests per number
- Total ~10 million operations

### Complexity Analysis:

| Range | Slow Operations | Fast Operations | Ratio |
|-------|----------------|----------------|-------|
| 1,000 | ~500K | ~15K | 33× |
| 5,000 | ~12.5M | ~105K | 120× |
| 10,000 | ~50M | ~315K | 160× |
| 46,225 | ~1B | ~10M | 100× |

## How to Run the Comparison

### 1. Build both versions:
```bash
swipl -q -s pascal_compiler.pl -- build-asm primes_slow_full.pas primes_slow_full
swipl -q -s pascal_compiler.pl -- build-asm primes_fast_full.pas primes_fast_full
```

### 2. Run with timing:
```bash
# Start the slow version (be patient!)
time ./primes_slow_full

# Run the fast version (instant!)
time ./primes_fast_full
```

### 3. Observe the difference:
- **Slow version**: Watch the progress dots appear slowly
- **Fast version**: See the progress dots fly by
- **Both**: Find exactly 4,792 primes up to 46,225

## Key Insights

1. **Algorithm choice dominates hardware**: A better algorithm on slow hardware beats a poor algorithm on fast hardware

2. **Complexity matters**: O(n²) vs O(n√n) makes orders of magnitude difference

3. **Mathematical optimizations pay off**: Simple insights (√n limit, skip evens) yield massive speedups

4. **Correctness is preserved**: Both approaches are mathematically equivalent

## Real-World Impact

In production systems:
- **Slow algorithm**: Might take hours for large ranges, impractical for real use
- **Fast algorithm**: Completes in seconds, suitable for production
- **Difference grows**: For larger ranges, the ratio becomes even more dramatic

## Conclusion

This full-range test dramatically illustrates why algorithmic optimization is one of the most important concepts in computer science. The fast algorithm isn't just "a bit better" - it's orders of magnitude faster while producing identical, mathematically correct results.