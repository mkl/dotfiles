#!/bin/zsh
# Claude Code Statusline — Catppuccin Mocha + Powerline
# Matches Starship prompt style
# Managed by chezmoi — do not edit manually
# Receives JSON from Claude Code on stdin
# Uses 256-color palette for reliable rendering in tmux over SSH

DATA=$(cat)

# -- Parse JSON -------------------------------------------------------
MODEL=$(echo "$DATA" | jq -r '.model.display_name // "Claude"')
USED_PCT=$(echo "$DATA" | jq -r '.context_window.used_percentage // 0')
CWD=$(echo "$DATA" | jq -r '.cwd // ""')
SESS_PCT=$(echo "$DATA" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK_PCT=$(echo "$DATA" | jq -r '.rate_limits.seven_day.used_percentage // empty')
SESS_PCT=${SESS_PCT%%.*}
WEEK_PCT=${WEEK_PCT%%.*}
# Uncommitted git changes (staged + unstaged)
if [ -n "$CWD" ]; then
  DIFF_STAT=$(git -C "$CWD" diff --numstat HEAD 2>/dev/null | awk '{a+=$1; d+=$2} END {print a+0, d+0}')
  LINES_ADD=${DIFF_STAT%% *}
  LINES_DEL=${DIFF_STAT##* }
else
  LINES_ADD=0
  LINES_DEL=0
fi

# Round percentage to integer
PCT=${USED_PCT%%.*}
: "${PCT:=0}"

# Progress bar (10 chars wide)
FILLED=$((PCT * 10 / 100))
EMPTY=$((10 - FILLED))
BAR=""
for ((i = 0; i < FILLED; i++)); do BAR+="█"; done
for ((i = 0; i < EMPTY; i++)); do BAR+="░"; done

# Folder name
FOLDER=$(basename "${CWD:-$PWD}")

# Git branch
BRANCH=""
[ -n "$CWD" ] && BRANCH=$(git -C "$CWD" symbolic-ref --short HEAD 2>/dev/null || true)

# -- Catppuccin Mocha Colors (256-color approximations) ---------------
fg256() { printf '\033[38;5;%dm' "$1"; }
bg256() { printf '\033[48;5;%dm' "$1"; }
RST=$'\033[0m'

# Closest 256-color matches for Catppuccin Mocha palette
MAUVE_FG=$(fg256 141);  MAUVE_BG=$(bg256 141)   # #cba6f7 → 141
GREEN_FG=$(fg256 114);  GREEN_BG=$(bg256 114)   # #a6e3a1 → 114
TEAL_FG=$(fg256 115);   TEAL_BG=$(bg256 115)    # #94e2d5 → 115
SURF0_FG=$(fg256 236);  SURF0_BG=$(bg256 236)   # #313244 → 236
CRUST_FG=$(fg256 234)                            # #11111b → 234
TEXT_FG=$(fg256 252)                             # #cdd6f4 → 252

# Severity → foreground color (blue < 60, yellow 60–79, red ≥ 80, gray if absent)
sev_fg() {
  local p=$1
  if [ -z "$p" ]; then echo 244; return; fi
  if [ "$p" -ge 80 ]; then echo 211
  elif [ "$p" -ge 60 ]; then echo 223
  else echo 111
  fi
}

# Context segment color shifts: blue -> yellow -> red based on usage
if [ "$PCT" -ge 80 ]; then
  CTX_FG=$(fg256 211); CTX_BG=$(bg256 211)   # red    #f38ba8 → 211
elif [ "$PCT" -ge 60 ]; then
  CTX_FG=$(fg256 223); CTX_BG=$(bg256 223)   # yellow #f9e2af → 223
else
  CTX_FG=$(fg256 111); CTX_BG=$(bg256 111)   # blue   #89b4fa → 111
fi

SESS_SEV_FG=$(fg256 "$(sev_fg "$SESS_PCT")")
WEEK_SEV_FG=$(fg256 "$(sev_fg "$WEEK_PCT")")

SEP=$'\ue0b0'
CAP=$'\ue0b6'
END=$'\ue0b4'

# -- Line 1: Model + Context ------------------------------------------
printf '%s' \
  "${MAUVE_FG}${CAP}${RST}" \
  "${MAUVE_BG}${CRUST_FG} 󰚩 ${MODEL} ${RST}" \
  "${CTX_BG}${MAUVE_FG}${SEP}${RST}" \
  "${CTX_BG}${CRUST_FG} ${PCT}% ${BAR} ${RST}" \
  "${CTX_FG}${END}${RST}"
echo

# -- Line 2: Folder + Branch + Lines Changed ---------------------------
printf '%s' \
  "${SURF0_FG}${CAP}${RST}" \
  "${SURF0_BG}${TEXT_FG}  ${FOLDER} ${RST}"

if [ -n "$BRANCH" ]; then
  printf '%s' \
    "${GREEN_BG}${SURF0_FG}${SEP}${RST}" \
    "${GREEN_BG}${CRUST_FG}  ${BRANCH} ${RST}" \
    "${TEAL_BG}${GREEN_FG}${SEP}${RST}"
else
  printf '%s' \
    "${TEAL_BG}${SURF0_FG}${SEP}${RST}"
fi

printf '%s' \
  "${TEAL_BG}${CRUST_FG} +${LINES_ADD} -${LINES_DEL} ${RST}" \
  "${SURF0_BG}${TEAL_FG}${SEP}${RST}"

if [ -n "$SESS_PCT" ]; then
  printf '%s' "${SURF0_BG}${SESS_SEV_FG} 󰥔 ${SESS_PCT}% ${RST}"
fi
if [ -n "$WEEK_PCT" ]; then
  printf '%s' "${SURF0_BG}${WEEK_SEV_FG} 󰃭 ${WEEK_PCT}% ${RST}"
fi
if [ -z "$SESS_PCT" ] && [ -z "$WEEK_PCT" ]; then
  printf '%s' "${SURF0_BG}${TEXT_FG} 󰥔 -- 󰃭 -- ${RST}"
fi

printf '%s' "${SURF0_FG}${END}${RST}"
echo
