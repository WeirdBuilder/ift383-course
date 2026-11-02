#!/usr/bin/env bash

set -u
export LC_ALL=C

# This starter contains two bounded defects. It also needs the optional status
# argument described in the assignment.
script_dir="$(cd "$(dirname "$0")" && pwd)"
log_file="$script_dir/access.log"
status_filter="${1:-}"
if [[ -n "$status_filter" && ! "$status_filter" =~ ^[0-9]{3}$ ]]; then
	echo "ERROR: status must be exactly three digits" >&2
	exit 1
fi

awk -v status="$status_filter" 'status == "" || $9 == status {print $1}' "$log_file" |
  sort |
  uniq -c |
  sort -k1,1nr -k2,2
