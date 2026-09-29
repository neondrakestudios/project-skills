#!/bin/sh
# Print every file under each given template directory, framed by its path,
# so the skill can read templates outside the target repo in one approved call.
for root in "$@"; do
  [ -d "$root" ] || { echo "=== MISSING $root ==="; continue; }
  echo "=== LAYER $root ==="
  (cd "$root" && find . -type f ! -path './.git/*' | LC_ALL=C sort) | while read -r f; do
    echo "=== FILE ${f#./} ==="
    cat "$root/$f"
    echo
  done
done
