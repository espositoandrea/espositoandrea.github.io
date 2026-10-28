#!/bin/sh
# Usage: post-files.sh POST
# Print the local files (relative to the site root) embedded in a post: images of its body, the photos and
# cover image of its front matter, and, for a post with references, its BibTeX file and the citation style.
front=$(awk 'NR == 1 && /^---$/ {f = 1; next} f && /^---$/ {exit} f' "$1")
{
  sed -E -f "$(dirname "$0")/preprocess.sed" "$1" | "$(dirname "$0")/image-srcs.sh"
  printf '%s\n' "$front" | sed -nE 's/^ *(- +)?(src|image): *//p'
  printf '%s\n' "$front" | sed -nE 's|^bibliography: *(.*)$|_bibliography/\1|p'
  printf '%s\n' "$front" | sed -nE 's|^bibliography: *.*$|nature.csl|p'
} | grep -v '://' | sed 's|^/||' | sort -u
