BASE_BIB = $(HOME)/Documents/Lavoro/Ricerca/Literature/Library.bib

_bibliography/references.bib: $(BASE_BIB)
	bib2bib \
		-ob "$@" \
		--expand --expand-xrefs \
		-c 'author : "Esposito" & ($$type <> "UNPUBLISHED" & $$type <> "MASTERSTHESIS" & $$type <> "misc" & !($$type : "PHDTHESIS" & type : "Bachelor Thesis"))' \
		"$<"
