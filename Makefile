BASE_BIB = $(HOME)/Documents/Lavoro/[03]\ Resources/Literature/Library.bib

_bibliography/references.bib: $(BASE_BIB)
	bib2bib \
		--expand --expand-xrefs \
		-c 'author : "Esposito" & ($$type <> "UNPUBLISHED" & $$type <> "MASTERSTHESIS" & $$type <> "misc" & !($$type : "PHDTHESIS" & type : "Bachelor Thesis")) & ! keywords : ".*cv/ignore.*"' \
		"$<" \
		| bibtool -- "preserve.key.case = on" -- "delete.field = { note }" \
		> "$@"
