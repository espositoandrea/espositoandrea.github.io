#!/bin/sh
# Print the source of every image in a (preprocessed) Markdown post read from stdin:
# <img src="..."> and ![caption](...). Photos of a photo essay (photo:<id>) are not images of their own.
grep -o -E 'src="[^"]*"|!\[[^]]*\]\([^) ]*' | sed -E 's/^src="//; s/"$//; s/^!\[[^]]*\]\(//' | grep -v '^photo:' || true
