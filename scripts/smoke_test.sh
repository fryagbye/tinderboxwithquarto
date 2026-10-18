#!/usr/bin/env bash
# smoke_test.sh — Regression smoke test for the Tinderbox/Quarto workflow.
#
# Verifies, in order:
#   1. Python environment    (uv sync --locked)
#   2. R environment         (renv::status)
#   3. Quarto availability   (quarto --version)
#   4. Render smoke tests    (book / manuscript / revealjs)
#   5. Unresolved cross-ref  (literal \@fig- etc. left in exported qmd,
#                             "?@label" left in rendered html)
#
# Idempotent: only renders; no external services required.
# Env overrides: QUARTO, UV, RSCRIPT, SKIP_RENDER=1

set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

PASS=0; FAIL=0; SKIP=0
ok()   { printf '  PASS  %s\n' "$1"; PASS=$((PASS+1)); }
bad()  { printf '  FAIL  %s\n' "$1"; FAIL=$((FAIL+1)); }
skip() { printf '  SKIP  %s\n' "$1"; SKIP=$((SKIP+1)); }
step() { printf '\n== %s\n' "$1"; }

QUARTO="${QUARTO:-quarto}"
command -v "$QUARTO" >/dev/null 2>&1 || QUARTO="/Applications/quarto/bin/quarto"
UV="${UV:-uv}"
command -v "$UV" >/dev/null 2>&1 || UV="$HOME/.local/bin/uv"
RSCRIPT="${RSCRIPT:-Rscript}"
command -v "$RSCRIPT" >/dev/null 2>&1 || RSCRIPT="/usr/local/bin/Rscript"

step "1. Python environment (uv sync --locked)"
if "$UV" sync --locked >/dev/null 2>&1; then
  ok "uv sync --locked"
else
  bad "uv sync --locked"
fi
# Activate the project venv so Quarto finds Jupyter
if [ -f .venv/bin/activate ]; then
  # shellcheck disable=SC1091
  . .venv/bin/activate
fi

step "2. R environment (renv)"
# Sub-project renders (output/, myproject/, ...) spawn Rscript with cwd
# inside the subdirectory. renv's activate.R falls back to getwd() as the
# project path, which would point at a nonexistent subdir renv library.
# RENV_PROJECT pins the project root; activation itself comes from the
# root .Rprofile (local) or ~/.Rprofile (CI step).
export RENV_PROJECT="$(pwd)"
if "$RSCRIPT" -e 'stopifnot(isTRUE(renv::status()$synchronized))' >/dev/null 2>&1; then
  ok "renv::status() clean"
else
  bad "renv::status() (run renv::restore())"
fi

step "3. Quarto"
if "$QUARTO" --version >/dev/null 2>&1; then
  ok "quarto --version → $("$QUARTO" --version 2>/dev/null | head -1)"
else
  bad "quarto not usable ($QUARTO)"
fi

proto_check() {
  # $1 label, $2 tbx file, $3 baseline tsv
  local label="$1" tbx="$2" base="$3"
  if [ ! -f "$tbx" ] || [ ! -f "$base" ]; then
    skip "$label (missing $tbx or $base)"
    return
  fi
  if scripts/check_proto_baseline.sh "$tbx" "$base" > ".smoke_proto_$$.log" 2>&1; then
    if grep -q '  EXTRA' ".smoke_proto_$$.log"; then
      ok "$label (extra protos — regenerate baseline if intentional)"
      grep '  EXTRA' ".smoke_proto_$$.log" | sed 's/^/    | /'
    else
      ok "$label"
    fi
    rm -f ".smoke_proto_$$.log"
  else
    bad "$label — proto assignments lost/changed (see below)"
    sed 's/^/    | /' ".smoke_proto_$$.log"
    rm -f ".smoke_proto_$$.log"
  fi
}

step "4. .tbx prototype integrity"
proto_check "Demo_TBX_for_Quarto.tbx"     "Demo_TBX_for_Quarto.tbx"     "scripts/baselines/Demo_TBX_for_Quarto.proto.tsv"
proto_check "TinderboxWithQuarto-0.6.0"   "TinderboxWithQuarto-0.6.0.tbx" "scripts/baselines/TinderboxWithQuarto-0.6.0.proto.tsv"

render_check() {
  # $1 label, $2 workdir, $3 render target, $4 expected output path
  local label="$1" dir="$2" target="$3" expect="$4"
  local log=".smoke_render_$(printf '%s' "$label" | tr ' ()' '___').log"
  if [ ! -d "$dir" ]; then skip "$label (no $dir)"; return; fi
  # Multi-format renders can transiently fail on typst mediabag
  # extraction; retry once before reporting failure.
  local attempt
  for attempt in 1 2; do
    # $target is intentionally word-split (contains "--to <fmt>")
    if (cd "$dir" && "$QUARTO" render $target >"$OLDPWD/$log" 2>&1); then
      if [ -e "$dir/$expect" ]; then
        ok "$label → $dir/$expect"
        rm -f "$log"
        return
      fi
      break
    fi
  done
  bad "$label render failed (see $log)"
  tail -25 "$log" | sed 's/^/    | /'
}

if [ "${SKIP_RENDER:-0}" = "1" ]; then
  skip "render tests (SKIP_RENDER=1)"
elif [ "${SMOKE_CI:-0}" = "1" ]; then
  # CI: avoid lualatex (TeX Live) — render manuscript per format.
  # Typst is bundled with Quarto so no external TeX is needed.
  step "5. Render smoke tests (CI mode)"
  render_check "book (typst)"       "output"      "."            "_booktypst/Tinderbox-file-for-Quarto.pdf"
  render_check "manuscript html"    "myproject"   ". --to html"  "_manuscript/index.html"
  render_check "manuscript typst"   "myproject"   ". --to typst" "_manuscript/index.pdf"
  render_check "manuscript docx"    "myproject"   ". --to docx"  "_manuscript/index.docx"
  render_check "manuscript jats"    "myproject"   ". --to jats"  "_manuscript/index.xml"
  render_check "revealjs"           "myrevealjs2" "index.qmd"    "index.html"
else
  step "5. Render smoke tests"
  render_check "book (typst)"  "output"      "."         "_booktypst/Tinderbox-file-for-Quarto.pdf"
  render_check "manuscript"    "myproject"   "."         "_manuscript/index.html"
  render_check "revealjs"      "myrevealjs2" "index.qmd" "index.html"
fi

step "6. Unresolved cross-reference scan"
UNRESOLVED=0
# "?@label" left in rendered html — real unresolved refs (FAIL)
LIT_HTML=$(grep -rln '?@\(fig\|tbl\|eq\|sec\|lst\)-' --include='*.html' output/_bookhtml output/_booktypst myproject/_manuscript 2>/dev/null || true)
if [ -n "$LIT_HTML" ]; then
  UNRESOLVED=1
  printf '%s\n' "$LIT_HTML" | sed 's/^/    ?@ref in /'
fi
# Literal \@fig- etc. in exported .qmd — WARNING only: documentation
# pages intentionally escape \@ to explain cross-reference syntax.
LIT_QMD=$(grep -rln '\\@\(fig\|tbl\|eq\|sec\|lst\)-' --include='*.qmd' output myproject myrevealjs myrevealjs2 2>/dev/null || true)
if [ -n "$LIT_QMD" ]; then
  printf '%s\n' "$LIT_QMD" | sed 's/^/    WARN: literal \\@ref in /'
fi
if [ "$UNRESOLVED" = "0" ]; then
  ok "no unresolved cross-references in rendered output"
else
  bad "unresolved cross-references found"
fi

step "Summary"
printf '  PASS=%d FAIL=%d SKIP=%d\n' "$PASS" "$FAIL" "$SKIP"
[ "$FAIL" = "0" ]
