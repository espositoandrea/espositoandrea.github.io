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
# {% cite key1 key2 --file refs.bib %} -> [@key1; @key2]   (references: the PDF lists them, see article.typ)
s/\{%-? *cite +([A-Za-z0-9_:.]+( +[A-Za-z0-9_:.]+)*)( +--[^%]*)? *-?%\}/[@\1]/g
:cite
s/(\[@[A-Za-z0-9_:.]+) ([A-Za-z0-9_:.])/\1; @\2/
t cite
# the list of references is added by the PDF template, under the heading of the post
/^\{%-? *bibliography .*%\}$/d
