---
name: ghostty-applescript
description: Write Ghostty terminal AppleScript layout scripts. Generates automation scripts for windows, tabs, pane splits, and command execution with correct syntax. Use for "Ghostty layout", "Ghostty AppleScript", "terminal pane layout script", or Zellij KDL to AppleScript conversion.
---

# Ghostty AppleScript

Write layout automation scripts for Ghostty (v1.3.0+) using its native AppleScript API.

## Object Hierarchy

```
application → windows → tabs → terminals
```

## Critical: Return Types

**Most common source of errors.** Each command returns a different type. You MUST convert to `terminal` before calling `split` or `input text`.

| Command | Returns | How to get a terminal |
|---------|---------|----------------------|
| `new tab in win` | **tab** | `focused terminal of theTab` |
| `new window` | **window** | `focused terminal of selected tab of win` |
| `split terminal direction ...` | **terminal** | Use directly |

### Anti-patterns (will crash)

```applescript
-- BAD: Using tab object directly with split
set t to new tab in win with configuration conf
split t direction right  -- ERROR: tab cannot receive split

-- BAD: Re-querying terminal from window after new tab
set newTab to new tab in win with configuration conf
set t to terminal 1 of selected tab of win  -- ERROR: "not in a splittable window"
```

### Correct patterns

```applescript
-- Current tab in current window
set win to front window
set t to focused terminal of selected tab of win

-- New tab in current window
set newTab to new tab in win with configuration conf
set t to focused terminal of newTab

-- New window
set win to new window with configuration conf
set t to focused terminal of selected tab of win
```

## Command Syntax Reference

**Wrong prepositions cause silent failures or error -1723 / -2741.**

| Command | Syntax | Preposition |
|---------|--------|-------------|
| Text input | `input text "cmd" & return to terminal` | **to** |
| Split pane | `split terminal direction right with configuration cfg` | keyword, no quotes |
| Perform action | `perform action "name" on terminal` | **on** |
| Focus | `focus terminal` | none |
| Select tab | `select tab tabRef` | none |
| New window | `new window with configuration cfg` | — |
| New tab | `new tab in window with configuration cfg` | **in** |

### Syntax Rules

- Direction values are **bare keywords**: `right`, `left`, `down`, `up`
  - `direction "right"` does NOT work
- Append `& return` to send a newline with `input text`

## Surface Configuration

```applescript
set cfg to new surface configuration
set initial working directory of cfg to "/path/to/project"
set font size of cfg to 13
set command of cfg to "zsh"
set environment variables of cfg to {"EDITOR=nvim", "FOO=bar"}
```

Working directory inheritance on split is undocumented. Always pass a configuration explicitly.

## Layout Patterns

### 2x3 Grid

Two approaches exist. Default to **row-first** unless the user prefers otherwise.

#### Row-first (default): split rows, then columns per row

Each row can be equalized independently. Better when top/bottom rows have different column counts.

```applescript
tell application "Ghostty"
    set conf to new surface configuration
    set initial working directory of conf to "/path/to/project"

    set win to front window
    set newTab to new tab in win with configuration conf
    set top1 to focused terminal of newTab

    -- Split into 2 rows
    set bot1 to split top1 direction down with configuration conf

    -- Split top row into 3 columns
    set top2 to split top1 direction right with configuration conf
    set top3 to split top2 direction right with configuration conf
    perform action "equalize_splits" on top1

    -- Split bottom row into 3 columns
    set bot2 to split bot1 direction right with configuration conf
    set bot3 to split bot2 direction right with configuration conf
    perform action "equalize_splits" on bot1

    -- Run commands
    input text "vim" & return to top1
    input text "lazygit" & return to bot2
    focus top1
end tell
```

#### Column-first: split columns, equalize, then split each column down

Simpler when every column has the same row count.

```applescript
tell application "Ghostty"
    set conf to new surface configuration
    set initial working directory of conf to "/path/to/project"

    set win to front window
    set newTab to new tab in win with configuration conf
    set col1 to focused terminal of newTab

    -- Split into 3 columns
    set col2 to split col1 direction right with configuration conf
    set col3 to split col2 direction right with configuration conf
    perform action "equalize_splits" on col1

    -- Split each column into 2 rows
    set bot1 to split col1 direction down with configuration conf
    set bot2 to split col2 direction down with configuration conf
    set bot3 to split col3 direction down with configuration conf

    -- Run commands
    input text "vim" & return to col1
    input text "lazygit" & return to bot2
    focus col1
end tell
```

### Multi-tab with Splits

```applescript
tell application "Ghostty"
    set conf to new surface configuration
    set initial working directory of conf to "/path/to/project"

    set w to new window with configuration conf
    set t1 to focused terminal of selected tab of w
    set t2 to split t1 direction right with configuration conf

    input text "npm run dev" & return to t1
    input text "tail -f logs/dev.log" & return to t2

    -- New tab
    set tab2 to new tab in w with configuration conf
    set t3 to focused terminal of tab2
    input text "nvim ." & return to t3

    -- Return to first tab
    select tab (tab 1 of w)
    focus t1
end tell
```

### Equalizing Splits

`split` always divides 50:50. Sequential splits produce uneven panes (e.g. 50|25|25). Use `equalize_splits` after creating splits in each row/group.

```applescript
-- After splitting into 3 columns:
perform action "equalize_splits" on anyTerminalInWindow
```

## Available Actions (perform action)

- `equalize_splits` — Equalize all splits in the window
- `resize_split:direction,pixels` — Resize split (e.g. `resize_split:right,50`)
- `toggle_split_zoom` — Zoom/unzoom current split
- `new_split:direction` — New split
- `goto_split:direction` — Navigate to adjacent split
- `close_surface` — Close pane

## Zellij KDL Conversion

| Zellij KDL | Ghostty AppleScript |
|-------------|---------------------|
| `tab name="x"` | `new tab in window with configuration conf` + `focused terminal of` |
| `pane split_direction="vertical"` | `split direction right` |
| `pane split_direction="horizontal"` | `split direction down` |
| `pane size="25%"` | `equalize_splits` (exact ratios not supported) |
| `pane cwd="dir"` | Separate `new surface configuration` with `initial working directory` |
| `command "cmd"` / `args "arg"` | `input text "cmd arg" & return to terminal` |
| `focus=true` | `select tab` + `focus terminal` |
| `start_suspended=true` | No equivalent (skip the `input text` call) |
| `close_on_exit=false` | No equivalent (Ghostty default behavior) |

## Documentation Reliability

Reference: https://ghostty.org/docs/features/applescript

| Section | Reliability | Notes |
|---------|-------------|-------|
| Commands (`new tab`, `split`, etc.) | Syntax is accurate | **Return types are poorly documented.** `new tab` appears to return a terminal but actually returns a tab |
| Tmux-style example | Use with caution | Uses `terminal 1 of selected tab of win` pattern which only works for `new window`, not `new tab` |
| `focused terminal of` | Essential | Barely mentioned in docs but is the correct way to convert tab → terminal |
| Properties (`initial working directory`, etc.) | Reliable | Works as documented |

## Execution

```bash
osascript path/to/layout.applescript
```

Requires macOS Automation permission (TCC). A dialog appears on first run.
Disable with `macos-applescript = false` in Ghostty config.