#!/usr/bin/env bash
# check_proto_baseline.sh — verify a .tbx file's prototype assignments
# against a committed baseline TSV (ID<TAB>proto).
#
# Catches silent proto loss, e.g. the incident where reopening a document
# in Tinderbox 11.8.0 dropped ~85% of proto= assignments before save.
#
# Verdicts:
#   MISSING   baseline has the assignment, current file lacks it → FAIL
#   MISMATCH  same ID, different proto value                    → FAIL
#   EXTRA     current file has an assignment not in baseline    → WARN only
#             (intentional additions are normal; regenerate the
#              baseline with gen_proto_baseline.sh to absorb them)
#
# Usage: check_proto_baseline.sh <file.tbx> <baseline.proto.tsv>
# Exit:  0 = OK or EXTRA-only, 1 = MISSING/MISMATCH, 2 = usage error
#
# If MISSING/MISMATCH is reported unexpectedly, restore with
# scripts/restore_prototypes_stamp.txt or check git history of the .tbx.

set -euo pipefail

if [ $# -ne 2 ] || [ ! -f "$1" ] || [ ! -f "$2" ]; then
  echo "usage: $0 <file.tbx> <baseline.proto.tsv>" >&2
  exit 2
fi

tbx="$1"; baseline="$2"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
"$(dirname "$0")/gen_proto_baseline.sh" "$tbx" > "$tmp"

report="$(awk -F '\t' '
  NR==FNR { base[$1]=$2; next }
          { cur[$1]=$2 }
  END {
    miss=mm=extra=0
    for (id in base)
      if (!(id in cur)) { printf "  MISSING   %s  %s\n", id, base[id]; miss++ }
    for (id in base)
      if ((id in cur) && cur[id] != base[id])
        { printf "  MISMATCH  %s  %s -> %s\n", id, base[id], cur[id]; mm++ }
    for (id in cur)
      if (!(id in base)) { printf "  EXTRA     %s  %s\n", id, cur[id]; extra++ }
    printf "  STATS     miss=%d mismatch=%d extra=%d\n", miss, mm, extra
  }' "$baseline" "$tmp")"

printf '%s\n' "$report"
n_base=$(wc -l < "$baseline" | tr -d ' ')
n_cur=$(wc -l < "$tmp" | tr -d ' ')
printf '  counts    baseline=%s current=%s\n' "$n_base" "$n_cur"

miss="$(printf '%s\n' "$report" | sed -nE 's/.*miss=([0-9]+).*/\1/p')"
mm="$(printf '%s\n' "$report" | sed -nE 's/.*mismatch=([0-9]+).*/\1/p')"
[ "${miss:-0}" -gt 0 ] || [ "${mm:-0}" -gt 0 ] && exit 1
exit 0
