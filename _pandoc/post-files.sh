#!/bin/sh
# Usage: post-files.sh POST
# Print the local files (relative to the site root) embedded in a post: images of its body and the photos
# and cover image of its front matter.
{
  sed -E -f "$(dirname "$0")/preprocess.sed" "$1" | "$(dirname "$0")/image-srcs.sh"
  awk 'NR == 1 && /^---$/ {f = 1; next} f && /^---$/ {exit} f' "$1" | sed -nE 's/^ *(- +)?(src|image): *//p'
} | grep -v '://' | sed 's|^/||' | sort -u
