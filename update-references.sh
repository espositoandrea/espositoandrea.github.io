#!/bin/sh

bib2bib \
	-ob ./_bibliography/references.bib \
	--expand --expand-xrefs \
	-c 'author : "Esposito"' \
	"$HOME/Documents/Lavoro/Ricerca/Literature/My Library.bib"
