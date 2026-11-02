#!/usr/bin/env bash

set -u
export LC_ALL=C

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
input_file="${1:-$script_dir/access.log}"

if [[ ! -f "$input_file" ]]; then
  printf 'ERROR: input log does not exist: %s\n' "$input_file" >&2
  exit 2
fi

# GUIDED JSON SLOT 1 OF 3
# Replace the next assignment with an awk command substitution that counts all
# input records and always produces a number.
total_requests="$(awk 'END {print NR + 0}' "$input_file")"

# GUIDED JSON SLOT 2 OF 3
# Replace the next assignment with an awk command substitution that counts only
# records whose exact ninth field is 404.
not_found_records="$(awk '$9 == 404 {count++} END {print count + 0}' "$input_file")"

# GUIDED JSON SLOT 3 OF 3
# Replace the next assignment with the guided pipeline that finds the most
# frequent 404 API path. An empty result is allowed when no record matches.
top_404_path="$(
	awk '$9 == 404 && $7 ~ /^\/api\// {print $7}' "$input_file" |
		sort |
		uniq -c |
		sort -k1,1nr -k2,2 |
		awk 'NR == 1 {print $2}'
	)"

# The supplied helper performs safe JSON serialization. Do not replace it with
# hand-built JSON text.
python3 "$script_dir/json_encode.py" \
  "$total_requests" "$not_found_records" "$top_404_path"
