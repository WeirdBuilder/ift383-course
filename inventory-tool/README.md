# Inventory Tool

This tool begins in Lab 5, is reorganized in Lab 6, and is packaged in Lab 7. Preserve earlier behavior as you extend it.

## Local use

Document the final command syntax and one reproducible example here.

python3 inventory.py DIRECTORY [--ext EXTENSION] [--format {table,json}] [--output FILE] [--min-size BYTES]

python3 inventory.py fixtures/base

## Options

Document the directory argument and each implemented option, including `--min-size`.

--ext : 
--format : 
--output : 
--min-size : 

## Output

Document the table and JSON fields. Keep diagnostics out of JSON report output.

## Configuration and logging

In Lab 6, document `--config` and `--log-file` with commands using the supplied fixture.

## Tests

Document the exact complete-suite command used for Labs 5 and 6.

python3 inventory.py fixtures/base --ext log --min-size 16

## Container

In Lab 7, document the Podman build and mounted-input run commands.
