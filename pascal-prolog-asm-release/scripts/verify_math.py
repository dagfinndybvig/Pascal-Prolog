#!/usr/bin/env python3
import json
import math
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIN_DIR = ROOT / ".verify_bin"


def run(cmd, *, input_text=None, timeout=240):
    return subprocess.run(
        cmd,
        cwd=ROOT,
        text=True,
        input=input_text,
        capture_output=True,
        timeout=timeout,
    )


def primes_upto(n):
    if n < 2:
        return []
    sieve = [True] * (n + 1)
    sieve[0] = False
    sieve[1] = False
    for i in range(2, int(n ** 0.5) + 1):
        if sieve[i]:
            for j in range(i * i, n + 1, i):
                sieve[j] = False
    return [i for i, is_p in enumerate(sieve) if is_p]


def parse_ints(text):
    return [int(x) for x in re.findall(r"\b\d+\b", text)]


def verify_prime_sequence(output, limit, stop_marker=None):
    segment = output.split(stop_marker)[0] if stop_marker else output
    values = [n for n in parse_ints(segment) if n <= limit]
    if 2 in values:
        values = values[values.index(2) :]
    expected = primes_upto(limit)
    return {
        "count": len(values),
        "matches": values == expected,
        "first10": values[:10],
        "last5": values[-5:],
    }


def verify_prime_sequence_allow_duplicate_banner_two(output, limit):
    values = [n for n in parse_ints(output) if n <= limit]
    if len(values) >= 2 and values[0] == 2 and values[1] == 2:
        values = values[1:]
    if 2 in values:
        values = values[values.index(2) :]
    expected = primes_upto(limit)
    return {
        "count": len(values),
        "matches": values == expected,
        "first10": values[:10],
        "last5": values[-5:],
    }


def build_example(pas_path):
    out_bin = BIN_DIR / pas_path.stem
    proc = run(
        [
            "swipl",
            "-q",
            "-s",
            "pascal_compiler.pl",
            "--",
            "build-asm",
            str(pas_path),
            str(out_bin),
        ]
    )
    return proc.returncode == 0, out_bin, proc.stderr.strip()


def main():
    BIN_DIR.mkdir(exist_ok=True)
    examples = sorted((ROOT / "examples").rglob("*.pas"))
    build_results = {}
    for pas in examples:
        ok, out_bin, stderr = build_example(pas.relative_to(ROOT))
        build_results[str(pas.relative_to(ROOT))] = {
            "ok": ok,
            "binary": str(out_bin),
            "stderr": stderr,
        }

    checks = {}
    small_prime_programs = [
        "primes_less_than_200_simple",
        "primes_no_division",
        "primes_mult_sub",
        "primes_sqrt_optimized",
        "primes_sqrt_no_div",
    ]
    for name in small_prime_programs:
        proc = run([str(BIN_DIR / name)])
        checks[name] = verify_prime_sequence(proc.stdout, 199)
        checks[name]["returncode"] = proc.returncode

    less200_v2 = run([str(BIN_DIR / "primes_less_than_200")])
    checks["primes_less_than_200"] = verify_prime_sequence_allow_duplicate_banner_two(
        less200_v2.stdout, 199
    )
    checks["primes_less_than_200"]["returncode"] = less200_v2.returncode

    for name in ["primes_simple_slow", "primes_simple_fast"]:
        proc = run([str(BIN_DIR / name)], timeout=300)
        m = re.search(r"Number of primes:\s*(\d+)", proc.stdout)
        checks[name] = {
            "returncode": proc.returncode,
            "reported_count": int(m.group(1)) if m else None,
            "expected_count": len(primes_upto(46000)),
        }

    summary_proc = run([str(BIN_DIR / "primes_with_summary")], timeout=300)
    checks["primes_with_summary"] = verify_prime_sequence(
        summary_proc.stdout, 46000, "Found these primes between"
    )
    checks["primes_with_summary"]["returncode"] = summary_proc.returncode

    comp_proc = run([str(BIN_DIR / "comprehensive_test")], input_text="7\n")
    checks["comprehensive_test"] = {
        "returncode": comp_proc.returncode,
        "tail": comp_proc.stdout.splitlines()[-4:],
    }

    result = {
        "build_results": build_results,
        "checks": checks,
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
