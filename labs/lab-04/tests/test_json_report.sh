#!/usr/bin/env bash

cd "$(dirname "$0")/.."

bash tests/reset_fixture.sh > /dev/null

if ! bash logmaint.sh --dir fixture --days 7 --dry-run > /dev/null; then
	echo "FAIL: dry-run returned a nonzero status"
	exit 1
fi

if python3 -m json.tool last_run.json > /dev/null &&
	grep -q '"mode": "dry-run"' last_run.json &&
	grep -q '"selected": 2' last_run.json
then
	echo "PASS: JSON report contains the expected dry-run values"
	exit 0
else
	echo "FAIL: JSON report is missing the expected values"
	exit 1
fi
