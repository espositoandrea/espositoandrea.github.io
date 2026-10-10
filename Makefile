# Posts that get a PDF version; each has a dedicated rule below
POST_PDFS = \
	assets/posts/pdfs/2024-11-26-beyond-automation.pdf \
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

# Print version of the images used in a post: remote <img src> URLs are downloaded once and converted to PDF
# (the name must match print_image in article.lua)
IMG_DIR = _build/images
img_name = $(shell printf '%s' '$(1)' | sed 's|.*/||; s|[^A-Za-z0-9._-]|_|g; s|\.[^.]*$$||')
post_image_urls = $(shell grep -o 'src="https\{0,1\}://[^"]*"' $(1) | sed 's/^src="//; s/"$$//')
post_images = $(foreach url,$(call post_image_urls,$(1)),$(IMG_DIR)/$(call img_name,$(url)).pdf)

define image_rule
$(IMG_DIR)/$(call img_name,$(1)).pdf:
	mkdir -p $$(@D)
	curl -fsSL '$(1)' -o '$$@.download'
	sips -s format pdf '$$@.download' --out '$$@' > /dev/null
	rm -f '$$@.download'
endef
$(foreach url,$(call post_image_urls,_posts/2024-11-26-beyond-automation.md),$(eval $(call image_rule,$(url))))

# Article-style post: custom pandoc writer (article.lua) emitting a two-column groff MM article.
# The Jekyll-only "{:...}" attribute lists are stripped; raw HTML figures are kept verbatim.
assets/posts/pdfs/2024-11-26-beyond-automation.pdf: _posts/2024-11-26-beyond-automation.md article.lua $(call post_images,_posts/2024-11-26-beyond-automation.md)
	sed 's/{:[^}]*}//g' $< | pandoc -f markdown-markdown_in_html_blocks -t article.lua \
		-M date="$(call post_date,$(basename $(notdir $@)))" \
		| groff -U -k -Tpdf -mm -mpdfpic > $@
