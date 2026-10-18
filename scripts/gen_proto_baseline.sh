#!/usr/bin/env bash
# gen_proto_baseline.sh — emit the ID→proto map of a .tbx file as TSV.
#
# Tinderbox serializes each note's prototype assignment as a `proto="..."`
# attribute on the item/agent/adornment start tag (not as a <link>).
# This script extracts every such assignment and prints "ID<TAB>proto"
# sorted by ID, suitable as the baseline for check_proto_baseline.sh.
#
# Usage:
#   scripts/gen_proto_baseline.sh Demo_TBX_for_Quarto.tbx \
#       > scripts/baselines/Demo_TBX_for_Quarto.proto.tsv
#
# Regenerate and commit the baseline whenever prototype assignments are
# changed intentionally (see README "Tinderbox 運用ルール").

set -euo pipefail

if [ $# -ne 1 ] || [ ! -f "$1" ]; then
  echo "usage: $0 <file.tbx>" >&2
  exit 2
fi

grep -oE '<(item|agent|adornment) [^>]*>' "$1" \
  | grep 'proto="' \
  | sed -E 's/.*ID="([0-9]+)".*proto="([^"]*)".*/\1\t\2/' \
  | sort -u
