#!/usr/bin/env bash

set -u
export LC_ALL=C

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
input_file="${1:-$script_dir/access.log}"

if [[ ! -f "$input_file" ]]; then
  printf 'ERROR: input log does not exist: %s\n' "$input_file" >&2
  exit 2
fi

printf 'TOTAL REQUESTS\n'
# CORE STUDENT SLOT 1 OF 3
# Replace the next command with a pipeline that prints one number.
wc -l < "$input_file"

printf '\nSTATUS COUNTS\n'
# CORE STUDENT SLOT 2 OF 3
# Replace the next command with a pipeline that prints "status count" rows.
awk '{print $9}' "$input_file" | sort -n | uniq -c | awk '{print $2, $1}'

printf '\nTOP 404 API PATHS\n'
# CORE STUDENT SLOT 3 OF 3
# Replace the next command with the required field-aware top-five pipeline.
awk '$9 == 404 && $7 ~ /^\/api\// {print $7}' "$input_file" | sort | uniq -c | sort -k1,1nr -k2,2 | head -n 5 | sed 's/^ *//'

printf '\nSERVER ERROR CLIENTS\n'
# INDEPENDENT TRANSFER SLOT
# Replace the next command with your distinct 500-through-599 client pipeline.
awk '$9 >= 500 && $9 <= 599 {print $1}' "$input_file" | sort | uniq -c | sort -k1,1nr -k2,2 | head -n 5 | sed 's/^ *//'
