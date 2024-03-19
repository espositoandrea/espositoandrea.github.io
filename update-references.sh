#!/bin/sh

bib2bib \
	-ob "${1:-/dev/stdout}" \
	--expand --expand-xrefs \
	-c 'author : "Esposito" & ($type <> "UNPUBLISHED" & $type <> "MASTERSTHESIS" & !($type : "PHDTHESIS" & type : "Bachelor Thesis"))' \
	"${2:-"$HOME/Documents/Lavoro/Ricerca/Literature/Library.bib"}"
