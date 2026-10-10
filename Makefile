# Posts that get a PDF version, named as in _posts/ without the extension, grouped by layout:
#   ARTICLES: two-column article (_pandoc/article.lua)
#   LETTERS:  blocked letter (_pandoc/letter.lua)
ARTICLES = 2024-11-26-beyond-automation
LETTERS = 2026-09-19-on-doom-scrolling-and-brain-fog

POST_PDFS = $(patsubst %,assets/posts/pdfs/%.pdf,$(ARTICLES) $(LETTERS))

all: _bibliography/references.bib $(POST_PDFS)

BASE_BIB = $(HOME)/Documents/Lavoro/NEW_WORK/70_Resources/literature/Library.bib

_bibliography/references.bib: $(BASE_BIB)
	bib2bib \
		--expand --expand-xrefs \
		-c 'author : "Esposito, Andrea" & ($$type <> "UNPUBLISHED" & $$type <> "MASTERSTHESIS" & $$type <> "misc" & !($$type : "PHDTHESIS" & type : "Bachelor Thesis")) & ! keywords : ".*cv/ignore.*"' \
		"$<" \
		| bibtool -- "preserve.key.case = on" -- "delete.field = { note }"  -- "delete.field = { file }" \
		> "$@"

# Jekyll convention: posts are named YYYY-MM-DD-title, so the date is the first 10 characters
post_date = $(shell printf '%s' '$(1)' | cut -c1-10)

# Print version of the images used in the posts: remote <img src> URLs are downloaded once and converted to PDF
# (the name must match print_image in _pandoc/article.lua)
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
$(foreach url,$(sort $(foreach post,$(ARTICLES) $(LETTERS),$(call post_image_urls,_posts/$(post).md))),$(eval $(call image_rule,$(url))))

# PDF of a post through the custom pandoc writer for its layout, then groff MM.
# The Jekyll-only "{:...}" attribute lists are stripped; raw HTML figures are kept verbatim.
# $(1) = post name, $(2) = layout (article or letter)
define pdf_rule
assets/posts/pdfs/$(1).pdf: _posts/$(1).md _pandoc/$(2).lua $(call post_images,_posts/$(1).md)
	sed 's/{:[^}]*}//g' $$< | pandoc -f markdown-markdown_in_html_blocks -t _pandoc/$(2).lua \
		-M date="$(call post_date,$(1))" \
		| groff -U -k -Tpdf -mm -mpdfpic > $$@
endef
$(foreach post,$(ARTICLES),$(eval $(call pdf_rule,$(post),article)))
$(foreach post,$(LETTERS),$(eval $(call pdf_rule,$(post),letter)))
