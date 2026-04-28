#!/usr/bin/env bash
# Install xen-skills into ~/.cursor/skills so Cursor loads them in every project.
#
# Usage:
#   bash setup-skills.sh              # symlink (edits in this repo apply everywhere)
#   bash setup-skills.sh --copy       # full copy (no symlink; use if links fail on Windows)
#   bash setup-skills.sh --force      # replace existing skill dirs in ~/.cursor/skills
#
# Requires: bash 4+. On Windows, use Git Bash or WSL.

set -euo pipefail

COPY=false
FORCE=false

usage() {
  sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy)  COPY=true ;;
    --force) FORCE=true ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Try: $0 --help" >&2
      exit 1
      ;;
  esac
  shift
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HOME}/.cursor/skills"

mkdir -p "$DEST"

installed=0
skipped=0

shopt -s nullglob
for skill_dir in "${SCRIPT_DIR}"/*/; do
  [[ -d "$skill_dir" ]] || continue
  [[ -f "${skill_dir}SKILL.md" ]] || continue

  name="$(basename "${skill_dir%/}")"
  target="${DEST}/${name}"

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ "$FORCE" == true ]]; then
      rm -rf "$target"
    else
      echo "Skip: ${name} (already exists at ${target}). Use --force to replace."
      skipped=$((skipped + 1))
      continue
    fi
  fi

  if [[ "$COPY" == true ]]; then
    cp -a "$skill_dir" "$target"
  else
    # Absolute source path avoids broken relative links when the symlink is resolved.
    ln -sfn "$(cd "$skill_dir" && pwd)" "$target"
  fi

  echo "Installed: ${name} -> ${target}"
  installed=$((installed + 1))
done
shopt -u nullglob

if [[ "$installed" -eq 0 && "$skipped" -eq 0 ]]; then
  echo "No skill folders found (expected ${SCRIPT_DIR}/*/SKILL.md)." >&2
  exit 1
fi

if [[ "$skipped" -gt 0 ]]; then
  echo "Done. Installed ${installed} skill(s). Skipped ${skipped} (already present; use --force to replace)."
else
  echo "Done. Installed ${installed} skill(s)."
fi
echo "Restart Cursor or open a new chat if skills do not appear immediately."
