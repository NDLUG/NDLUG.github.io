#!/bin/sh

# NOTE: this script is meant to be called by the Makefile, not directly

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 INPUT OUTPUT"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

MD="$(ls -1 content/*.md)"
ITEMS=""
for file in $MD; do
    ITEMS="${ITEMS}$(echo "$file" | sed -e 's|^content/|posts/|' -e 's|\.md$|\.html|')\t"
    ITEMS="${ITEMS}$(sed -nE 's|^date: (.*)$|\1|p' "$file")\t"
    ITEMS="${ITEMS}$(sed -nE 's|^title: (.*)$|\1|p' "$file")\n"
done

ITEMS="$(printf '%b' "$ITEMS" | sort -k2 -r | awk -F '\t' '{print "<li><a href=\"" $1 "\">" $2 "</a>: " $3 "</li>"}')"

awk -v items="$ITEMS" '{sub(/\{\{posts\}\}/, items, $0); print $0}' "$INPUT" > "$OUTPUT"
