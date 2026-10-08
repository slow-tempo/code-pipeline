#!/usr/bin/env bash
# Install the code-pipeline skill.
# Usage: ./install.sh [target-dir]   (default: ~/.agents/skills/code-pipeline)
set -euo pipefail
TARGET="${1:-$HOME/.agents/skills/code-pipeline}"
mkdir -p "$TARGET"
cp "$(dirname "$0")/skills/code-pipeline/SKILL.md" "$TARGET/SKILL.md"
echo "installed → $TARGET"
