#!/bin/sh
# Print the source of every image in a (preprocessed) Markdown post read from stdin:
# <img src="..."> and ![caption](...)
grep -o -E 'src="[^"]*"|!\[[^]]*\]\([^) ]*' | sed -E 's/^src="//; s/"$//; s/^!\[[^]]*\]\(//'
