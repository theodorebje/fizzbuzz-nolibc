#!/usr/bin/env python3
"""
Test runner for 'make instructions' output.

Runs `make -s instructions`, captures its stdout, and compares the numeric
value to a reference integer stored in bin/instructions.txt.

- If the reference file does not exist, it is created with the output value
  and the test passes.
- If the reference file exists, the test passes only when the new output
  value is < the reference value.
"""

import os
import subprocess
import sys

def main() -> int:
    target_file = "bin/instructions.txt"
    make_cmd = ["make", "-s", "instructions"]

    # Run make and capture stdout (ignore stderr)
    try:
        result = subprocess.run(
            make_cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            check=False
        )
    except FileNotFoundError:
        print("Error: 'make' command not found.", file=sys.stderr)
        return 1

    if result.returncode != 0:
        print(f"Error: `{' '.join(make_cmd)}` failed with exit code {result.returncode}",
              file=sys.stderr)
        return 1

    # Parse output as integer (strip whitespace, handle possible newline)
    raw_output = result.stdout.strip()
    try:
        output_value = int(raw_output)
    except ValueError:
        print(f"Error: make output is not an integer: {raw_output!r}", file=sys.stderr)
        return 1

    # Ensure directory exists
    os.makedirs(os.path.dirname(target_file), exist_ok=True)

    # If reference file doesn't exist, create it and pass
    if not os.path.exists(target_file):
        with open(target_file, "w", encoding="utf-8") as f:
            f.write(str(output_value))
        print(f"Created reference file {target_file} with value {output_value}")
        return 0

    # Read reference value
    with open(target_file, "r", encoding="utf-8") as f:
        ref_content = f.read().strip()
    try:
        ref_value = int(ref_content)
    except ValueError:
        print(f"Error: reference file {target_file} does not contain a valid integer: {ref_content!r}",
              file=sys.stderr)
        return 1

    # Compare
    if output_value < ref_value:
        print(f"PASS: {output_value} < {ref_value}")
        return 0
    else:
        print(f"FAIL: {output_value} >= {ref_value}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
