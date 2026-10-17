#!/bin/bash
# Generated independent review runner for tinderboxwithquarto.
# It prefers Claude/Codex, then falls back to Antigravity/Gemini CLI when a non-interactive mode is available.
set -euo pipefail

PROJECT_NAME="tinderboxwithquarto"
OUT_DIR="${TMPDIR:-/tmp}/antigravity-second-opinion-${PROJECT_NAME}"
mkdir -p "$OUT_DIR"
DIFF_FILE="$OUT_DIR/input.diff"
PROMPT_FILE="$OUT_DIR/review-prompt.md"
SUMMARY_FILE="$OUT_DIR/README.txt"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git diff HEAD > "$DIFF_FILE"
else
  printf "No git repository detected. Add target files or diff manually before running review.\n" > "$DIFF_FILE"
fi

cat > "$PROMPT_FILE" <<'PROMPT_EOF'
You are an independent senior code reviewer.

Review the supplied diff/code for:
1. correctness bugs and boundary cases
2. security and data-loss risks
3. state races, async cleanup, and resource leaks
4. type-safety and validation gaps
5. unnecessary complexity that can be simplified without changing behavior

Findings format:
[LEVEL] file:line - concise issue and concrete fix
LEVEL: CRITICAL / WARNING / INFO

End with totals and one of: APPROVE / NEEDS_CHANGES.
PROMPT_EOF

run_claude() {
  local bin="$1"
  if [ -x "$bin" ]; then
    "$bin" -p "$(cat "$PROMPT_FILE")

Diff:
$(cat "$DIFF_FILE")" < /dev/null > "$OUT_DIR/claude-opinion.md"
    return 0
  fi
  return 1
}

run_codex() {
  local bin="$1"
  if [ -x "$bin" ]; then
    unset OPENAI_API_KEY 2>/dev/null || true
    cat "$DIFF_FILE" | "$bin" exec --skip-git-repo-check -s read-only -o "$OUT_DIR/codex-opinion.md" "$(cat "$PROMPT_FILE")" >"$OUT_DIR/codex-stdout.log" 2>"$OUT_DIR/codex-stderr.log"
    return 0
  fi
  return 1
}

find_cmd() {
  command -v "$1" 2>/dev/null || true
}

run_agy_fallback() {
  local bin
  bin="$(find_cmd agy)"
  if [ -z "$bin" ]; then bin="$(find_cmd antigravity)"; fi
  if [ -z "$bin" ]; then bin="$(find_cmd gemini)"; fi
  if [ -z "$bin" ]; then return 1; fi

  cat "$PROMPT_FILE" "$DIFF_FILE" > "$OUT_DIR/agy-review-input.md"

  # Current Antigravity CLI documentation is TUI-first. Use only common non-interactive flags
  # when the installed binary advertises them, otherwise fail closed with the prepared prompt.
  local help_text
  help_text="$("$bin" --help 2>&1 || true)"
  if printf "%s" "$help_text" | grep -Eq -- '(^|[[:space:]])(-p|--prompt)(,|[[:space:]])'; then
    "$bin" -p "$(cat "$OUT_DIR/agy-review-input.md")" > "$OUT_DIR/agy-opinion.md"
    return 0
  fi
  if printf "%s" "$help_text" | grep -Eq -- '(^|[[:space:]])exec(,|[[:space:]])'; then
    "$bin" exec "$(cat "$OUT_DIR/agy-review-input.md")" > "$OUT_DIR/agy-opinion.md"
    return 0
  fi

  printf "Antigravity/Gemini CLI found at %s, but no supported non-interactive review mode was advertised.\n" "$bin" > "$OUT_DIR/agy-opinion.md"
  printf "Open AGY manually and submit: %s\n" "$OUT_DIR/agy-review-input.md" >> "$OUT_DIR/agy-opinion.md"
  return 2
}

review_count=0
run_claude "/Users/haratake/.local/bin/claude" && review_count=$((review_count + 1)) || true
run_codex "/Users/haratake/.nvm/versions/node/v22.18.0/bin/codex" && review_count=$((review_count + 1)) || true

if [ "$review_count" -eq 0 ]; then
  run_agy_fallback && review_count=$((review_count + 1)) || true
fi

{
  printf "Second opinion output directory: %s\n" "$OUT_DIR"
  printf "Review files generated:\n"
  find "$OUT_DIR" -maxdepth 1 -type f -name '*opinion.md' -print
} > "$SUMMARY_FILE"

cat "$SUMMARY_FILE"

if [ "$review_count" -eq 0 ]; then
  printf "No automated reviewer completed. Inspect %s and run the fallback manually.\n" "$OUT_DIR/agy-review-input.md" >&2
  exit 2
fi
