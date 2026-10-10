# Jekyll-only syntax in posts, turned into plain Markdown before pandoc reads it (run with sed -E -f)
# kramdown attribute lists: [text](url){:target="_blank"}
s/\{:[^}]*\}//g
# {% link path/to/file %} -> /path/to/file
s/\{%-? *link +([^ %]+) *-?%\}/\/\1/g
# {{ '/path' | relative_url }} (or absolute_url) -> /path
s/\{\{ *['"]([^'"]*)['"] *\| *(relative_url|absolute_url) *\}\}/\1/g
