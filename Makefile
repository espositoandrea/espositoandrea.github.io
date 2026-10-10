# PDFs are built for posts with a roff source, plus those with a dedicated rule below
POST_PDFS = \
	$(patsubst assets/posts/roff/%/main.mm,assets/posts/pdfs/%.pdf,$(wildcard assets/posts/roff/*/main.mm)) \
	assets/posts/pdfs/2026-09-19-on-doom-scrolling-and-brain-fog.pdf

all: _bibliography/references.bib $(POST_PDFS)

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

# Jekyll convention: posts are named YYYY-MM-DD-title, so the date is the first 10 characters
post_date = $(shell printf '%s' '$(1)' | cut -c1-10)


assets/posts/pdfs/%.pdf: assets/posts/roff/%/main.mm
	cd $(dir $<) && groff -U -Tpdf -mm -kKutf8 -tep < $(notdir $<) > ../../../../$@

assets/posts/pdfs/%.pdf: _posts/%.md
	pandoc \
		-V institution="$$institution" \
		-M date="$(call post_date,$(basename $(notdir $@)))" \
		-f markdown -t ms --template=template.ms \
		-so - \
		$< | groff -eTpdf -ms -mpdfmark > $@

# Letter-style post: custom pandoc writer (letter.lua) emitting a blocked letter in groff MM
assets/posts/pdfs/2026-09-19-on-doom-scrolling-and-brain-fog.pdf: _posts/2026-09-19-on-doom-scrolling-and-brain-fog.md letter.lua
	pandoc -f markdown -t letter.lua \
		-M date="$(call post_date,$(basename $(notdir $@)))" \
		$< | groff -k -Tpdf -mm > $@
