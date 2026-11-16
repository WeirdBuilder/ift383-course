#!/usr/bin/env python3

from pathlib import Path
import subprocess
import sys

TOOL_ROOT = Path(__file__).resolve().parents[1]
SCRIPT = TOOL_ROOT / "inventory.py"

def test_exact_minimum_is_included(tmp_path: Path) -> None:
    exact = tmp_path / "exact.txt"
    exact.write_bytes(b"1234")
    smaller = tmp_path / "smaller.txt"
    smaller.write_bytes(b"123")

    result = subprocess.run(
            [sys.executable, str(SCRIPT), str(tmp_path), "--min-size", "4"],
            cwd=TOOL_ROOT,
            text=True,
            capture_output=True,
            check=False,
    )

    assert result.returncode == 0
    assert "exact.txt" in result.stdout
    assert "smaller.txt" not in result.stdout
