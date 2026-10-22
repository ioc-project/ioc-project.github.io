#!/usr/bin/env bash
# Copy diagrams into the MkDocs asset tree.
#
# diagrams/ is the single source of truth for images; docs/assets/diagrams is a
# build artifact (gitignored). Run this before `mkdocs build` or `mkdocs serve`.
# The Pages workflow runs it too, so CI and local preview stay identical.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="$repo_root/diagrams"
dest="$repo_root/docs/assets/diagrams"

# Clear first: a renamed or deleted diagram must not linger here as a stale copy
# that still resolves in the built site.
rm -rf "$dest"
mkdir -p "$dest"
# Top level only — light/ holds the pre-restyle originals, and archi-explorer/
# and charter-strategy/ build their own outputs.
find "$src" -maxdepth 1 -type f \( -name '*.png' -o -name '*.svg' \) -exec cp {} "$dest/" \;

echo "Synced $(find "$dest" -type f | wc -l | tr -d ' ') diagram files into docs/assets/diagrams"
