#!/bin/sh

bib2bib \
	-ob "${1:-/dev/stdout}" \
	--expand --expand-xrefs \
	-c 'author : "Esposito" & $type <> "UNPUBLISHED"' \
	"${2:-"$HOME/Documents/Lavoro/Ricerca/Literature/My Library.bib"}"
