# Running the Performance Comparison

This guide shows how to actually run and compare the slowest vs fastest prime algorithms.

## Step-by-Step Comparison

### 1. Build Both Versions

```bash
# Build the slow version (division-free, no optimizations)
swipl -q -s pascal_compiler.pl -- build-asm primes_no_division.pas primes_slow

# Build the fast version (square root optimized)
swipl -q -s pascal_compiler.pl -- build-asm primes_sqrt_optimized.pas primes_fast
```

### 2. Run the Slow Version

```bash
# Run with timing
time ./primes_slow
```

**Expected output**: 
- Visible delay (several seconds)
- Lists all primes found
- Shows the algorithm's progress

### 3. Run the Fast Version

```bash
# Run with timing
time ./primes_fast
```

**Expected output**:
- Nearly instantaneous completion
- Same list of primes
- Much faster execution

### 4. Compare Results

Both programs should find the **same primes** but with dramatically different execution times:

```
Slow version:  3-5 seconds (visible delay)
Fast version:  <0.1 seconds (instantaneous)
```

## What This Demonstrates

1. **Mathematical Equivalence**: Both find identical primes
2. **Performance Difference**: Orders of magnitude speedup
3. **Algorithm Impact**: Choice matters more than hardware
4. **Optimization Value**: Simple insights yield huge gains

## Range Testing

### Test Different Ranges

Modify the programs to test different upper limits:

```bash
# Edit primes_no_division.pas and primes_sqrt_optimized.pas
# Change the while condition: while i <= 2000 do

# Rebuild and test
swipl -q -s pascal_compiler.pl -- build-asm primes_no_division.pas primes_slow_2000
swipl -q -s pascal_compiler.pl -- build-asm primes_sqrt_optimized.pas primes_fast_2000

# Run and compare
./primes_slow_2000   # Even slower
./primes_fast_2000   # Still fast
```

### Expected Performance by Range

| Range  | Slow Time | Fast Time | Ratio  |
|--------|-----------|-----------|--------|
| 1,000  | ~3 sec    | ~0.05 sec | 60×     |
| 2,000  | ~12 sec   | ~0.1 sec  | 120×    |
| 5,000  | ~75 sec   | ~0.3 sec  | 250×    |

## Key Observations

1. **Slow version scales poorly**: Time increases quadratically
2. **Fast version scales well**: Time increases linearly with √n
3. **Ratio grows with range**: Larger ranges show bigger differences
4. **Both are correct**: Same mathematical results

## Conclusion

This practical comparison demonstrates why algorithmic optimization is crucial in computer science. The fast algorithm isn't just "a bit better" - it's orders of magnitude faster while producing identical results!