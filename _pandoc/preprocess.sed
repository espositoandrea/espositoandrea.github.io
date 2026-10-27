# Jekyll-only syntax in posts, turned into plain Markdown before pandoc reads it (run with sed -E -f)
# kramdown attribute lists: [text](url){:target="_blank"}
s/\{:[^}]*\}//g
# {% link path/to/file %} -> /path/to/file
s/\{%-? *link +([^ %]+) *-?%\}/\/\1/g
# {{ '/path' | relative_url }} (or absolute_url) -> /path
s/\{\{ *['"]([^'"]*)['"] *\| *(relative_url|absolute_url) *\}\}/\1/g
# {% include photo.html id="x" [width="full"] %} -> ![](photo:x){layout="full"}   (photo essays, see photo.lua)
# {% include photo.html n=2 [width="full"] %}    -> ![](photo:#2){layout="full"}
s/\{%-? *include +photo\.html +id="([^"]+)"( +width="([^"]*)")? *-?%\}/![](photo:\1){layout="\3"}/g
s/\{%-? *include +photo\.html +n=([0-9]+)( +width="([^"]*)")? *-?%\}/![](photo:#\1){layout="\3"}/g
