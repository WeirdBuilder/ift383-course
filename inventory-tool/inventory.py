#!/usr/bin/env python3
"""Lab 5 starting point for the continuing inventory command-line tool."""

from __future__ import annotations

import argparse
import sys
import json
from pathlib import Path
from typing import Sequence


def extension_for(path: Path) -> str:
    """Return the displayed extension for one path."""

    # Seeded defect: extensionless files are labeled incorrectly.
    return path.suffix.removeprefix(".")


def scan_directory(directory: str | Path, requested_extension: str | None = None, min_size: int = 0,) -> list[dict[str, object]]:
    """Return one record per ordinary file in the requested directory."""

    # Seeded defect: the supplied directory is not yet used as the scan root.
    root = Path(directory).expanduser().resolve()
    records: list[dict[str, object]] = []
    for item in sorted(root.iterdir(), key=lambda candidate: candidate.name):
        if not item.is_file():
            continue
        if requested_extension is not None and item.suffix.lower() != requested_extension:
            continue

        size = item.stat().st_size

        if size < min_size:
            continue

        records.append(
                {
                    "name": item.name,
                    "size": item.stat().st_size,
                    "extension": extension_for(item),
                }
        )
    return records


def render_table(records: list[dict[str, object]]) -> str:
    lines = ["NAME\tSIZE\tEXTENSION"]
    for record in records:
        lines.append(f"{record['name']}\t{record['size']}\t{record['extension']}")
    return "\n".join(lines)

def render_json(records: list[dict[str, object]]) -> str:
    return json.dumps(records, indent=2, sort_keys=True)

def nonnegative_int(value: str) -> int:
    try:
        number = int(value)
    except ValueError as exc:
        raise argparse.ArgumentTypeError("must be an integer") from exc
    if number < 0:
        raise argparse.ArgumentTypeError("must be nonnegative")
    return number

def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Report ordinary files in one directory.")
    parser.add_argument("directory", help="directory to inspect")
    parser.add_argument("--min-size", type=nonnegative_int, default=0, metavar="BYTES", help="include only files at least this many bytes",) 
    parser.add_argument("--ext", help="include only this extension")
    parser.add_argument("--format", choices=("table", "json"), default="table", help="report format (default: table)",)
    parser.add_argument("--output", type=Path, help="write the report to this file")
    # STUDENT SLOT (Lab 5): add --ext, --format, and --output here.
    # STUDENT SLOT (Lab 5 transfer): add --min-size after base behavior works.
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    requested_extension = None

    if args.ext is not None:
        requested_extension = "." + args.ext.removeprefix(".").lower()

    # STUDENT SLOT (Lab 5): validate the requested directory and apply options.
    try:
        records = scan_directory(args.directory, requested_extension=requested_extension, min_size=args.min_size,)
    except OSError as exc:
        print(f"inventory: {exc}", file=sys.stderr)
        return 2

    if args.format == "json":
        report = render_json(records)
    else:
        report = render_table(records)

    try:
        if args.output is None:
            print(report)
        else:
            args.output.write_text(report + "\n", encoding="utf-8")

    except OSError as exc:
        print(f"inventory: {exc}", file=sys.stderr)
        return 2

    # STUDENT SLOT (Lab 5): select table or JSON and honor --output.


if __name__ == "__main__":
    raise SystemExit(main())
