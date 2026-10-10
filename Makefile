# Posts that get a PDF version, named as in _posts/ without the extension, grouped by layout:
#   ARTICLES: two-column article (_pandoc/article.lua)
#   LETTERS:  blocked letter (_pandoc/letter.lua)
ARTICLES = 2024-11-26-beyond-automation
LETTERS = 2026-09-19-on-doom-scrolling-and-brain-fog 2025-09-07-my-struggle-with-boredom-in-an-uninteresting-city

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

# Jekyll-only syntax ({% link %}, {:...} attributes, ...) is rewritten before pandoc reads a post
PREPROCESS = sed -E -f _pandoc/preprocess.sed
SITE_URL = $(shell awk -F'"' '/^url:/ {print $$2}' _config.yml)

# Print version of the images used in the posts: remote and local images are converted to PDF (remote ones
# are downloaded once first), local PDFs are used as they are. Names must match print_image in _pandoc/common.lua
IMG_DIR = _build/images
img_name = $(shell printf '%s' '$(1)' | sed 's|.*/||; s|[^A-Za-z0-9._-]|_|g; s|\.[^.]*$$||')
is_remote = $(findstring ://,$(1))
is_pdf = $(filter %.pdf,$(1))
post_image_srcs = $(shell $(PREPROCESS) $(1) | _pandoc/image-srcs.sh)
img_pdf = $(if $(or $(call is_remote,$(1)),$(if $(call is_pdf,$(1)),,x)),$(IMG_DIR)/$(call img_name,$(1)).pdf,$(patsubst /%,%,$(1)))
post_images = $(foreach src,$(call post_image_srcs,$(1)),$(call img_pdf,$(src)))

define remote_image_rule
$(IMG_DIR)/$(call img_name,$(1)).pdf:
	mkdir -p $$(@D)
	curl -fsSL '$(1)' -o '$$@.download'
	sips -s format pdf '$$@.download' --out '$$@' > /dev/null
	rm -f '$$@.download'
endef

define local_image_rule
$(IMG_DIR)/$(call img_name,$(1)).pdf: $(patsubst /%,%,$(1))
	mkdir -p $$(@D)
	sips -s format pdf '$$<' --out '$$@' > /dev/null
endef

$(foreach src,$(sort $(foreach post,$(ARTICLES) $(LETTERS),$(call post_image_srcs,_posts/$(post).md))),\
	$(if $(call is_remote,$(src)),$(eval $(call remote_image_rule,$(src))),\
	$(if $(call is_pdf,$(src)),,$(eval $(call local_image_rule,$(src))))))

# PDF of a post through the custom pandoc writer for its layout, then groff MM.
# Raw HTML figures are kept verbatim; site-relative links are made absolute with SITE_URL.
# $(1) = post name, $(2) = layout (article or letter)
define pdf_rule
assets/posts/pdfs/$(1).pdf: _posts/$(1).md _pandoc/$(2).lua _pandoc/common.lua _pandoc/preprocess.sed $(call post_images,_posts/$(1).md)
	$(PREPROCESS) $$< | pandoc -f markdown-markdown_in_html_blocks -t _pandoc/$(2).lua \
		-M date="$(call post_date,$(1))" -M site_url="$(SITE_URL)" \
		| groff -U -k -Tpdf -mm -mpdfpic > $$@
endef
$(foreach post,$(ARTICLES),$(eval $(call pdf_rule,$(post),article)))
$(foreach post,$(LETTERS),$(eval $(call pdf_rule,$(post),letter)))
