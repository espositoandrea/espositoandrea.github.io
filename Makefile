BASE_BIB = $(HOME)/Documents/Lavoro/NEW_WORK/70_Resources/literature/Library.bib

_bibliography/references.bib: $(BASE_BIB)
	bib2bib \
		--expand --expand-xrefs \
		-c 'author : "Esposito, Andrea" & ($$type <> "UNPUBLISHED" & $$type <> "MASTERSTHESIS" & $$type <> "misc" & !($$type : "PHDTHESIS" & type : "Bachelor Thesis")) & ! keywords : ".*cv/ignore.*"' \
		"$<" \
		| bibtool -- "preserve.key.case = on" -- "delete.field = { note }"  -- "delete.field = { file }" \
		> "$@"

define institution
Department of Computer Science
University of Bari Aldo Moro
Via E. Orabona 4, 70125 Bari, Italy
endef
export institution


assets/posts/pdfs/%.pdf: assets/posts/roff/%/main.mm
	cd $(dir $<) && groff -U -Tpdf -mm -mpdfmark -kKutf8 -tep < $(notdir $<) > ../../../../$@

assets/posts/pdfs/%.pdf: _posts/%.md
	pandoc \
		-V institution="$$institution" \
		-f markdown -t ms --template=template.ms \
		-so - \
		$< | groff -eTpdf -ms -mpdfmark > $@

assets/posts/pdfs/2026-09-19-on-doom-scrolling-and-brain-fog.pdf: _posts/2026-09-19-on-doom-scrolling-and-brain-fog.md
	sed -e '$$ d' $< | \
		pandoc -f markdown -o $@ --template=scrlttr2 \
		-V "closing=$$(sed -ne '$$ p' $< | tr -d '\n')"
