#!/usr/bin/env python3
"""
Run 'make run' and compare its stdout with the contents of expected.txt.
Exit with 0 if they match, otherwise show diff and exit with 1.
"""

import subprocess
import sys
import os
import difflib

EXPECTED_FILE = "tests/expected.txt"

def main():
    # Check if expected.txt exists
    if not os.path.isfile(EXPECTED_FILE):
        print(f"Error: {EXPECTED_FILE} not found in current directory.", file=sys.stderr)
        sys.exit(1)

    # Run 'make run' and capture stdout (and stderr for debugging), with a 1s timeout
    try:
        result = subprocess.run(
            ["make", "-s", "run"],
            capture_output=True,
            text=True,
            check=False,  # We'll handle return code manually
            timeout=1,    # Timeout after 1 second
        )
    except FileNotFoundError:
        print("Error: 'make' command not found. Is make installed?", file=sys.stderr)
        sys.exit(1)
    except subprocess.TimeoutExpired:
        print("Error: 'make run' timed out after 1 second", file=sys.stderr)
        sys.exit(1)

    # If make failed, print stderr and exit with its return code
    if result.returncode != 0:
        print("Error: 'make run' failed with return code", result.returncode, file=sys.stderr)
        if result.stderr:
            print("stderr:", result.stderr, file=sys.stderr)
        sys.exit(result.returncode)

    # Read expected output
    with open(EXPECTED_FILE, "r") as f:
        expected = f.read()

    actual = result.stdout

    # Compare
    if actual == expected:
        print("Output matches expected.txt")
        sys.exit(0)
    else:
        print("Output does NOT match expected.txt. Diff:")
        # Show unified diff between expected and actual
        diff = difflib.unified_diff(
            expected.splitlines(keepends=True),
            actual.splitlines(keepends=True),
            fromfile="expected.txt",
            tofile="actual output",
        )
        sys.stdout.writelines(diff)
        sys.exit(1)


if __name__ == "__main__":
    main()
