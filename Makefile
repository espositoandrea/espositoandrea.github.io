# Posts that get a PDF version, named as in _posts/ without the extension, grouped by layout
# (_pandoc/<layout>.lua reshapes the post, _pandoc/<layout>.typ lays it out, Typst compiles it):
#   ARTICLES: two-column article
#   LETTERS:  blocked letter
ARTICLES = 2024-11-26-beyond-automation
LETTERS = 2026-09-19-on-doom-scrolling-and-brain-fog 2025-09-07-my-struggle-with-boredom-in-an-uninteresting-city 2025-08-30-typewriter 2025-10-04-on-compendiums-and-general-notebooks-usage

POST_PDFS = $(patsubst %,assets/posts/pdfs/%.pdf,$(ARTICLES) $(LETTERS))

all: _bibliography/references.bib pdfs

# Only the post PDFs (what the deploy workflow builds)
pdfs: $(POST_PDFS)

.PHONY: all pdfs FORCE
FORCE:

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

# Remote images of the posts are downloaded once (Typst reads local images, and recognises their format, by itself).
# Names must match print_image in _pandoc/common.lua
IMG_DIR = _build/images
img_name = $(shell printf '%s' '$(1)' | sed 's|.*/||; s|[^A-Za-z0-9._-]|_|g; s|\.[^.]*$$||')
is_remote = $(findstring ://,$(1))
post_image_srcs = $(shell $(PREPROCESS) $(1) | _pandoc/image-srcs.sh)
remote_img = $(if $(call is_remote,$(1)),$(IMG_DIR)/$(call img_name,$(1)).img)
post_images = $(foreach src,$(call post_image_srcs,$(1)),$(call remote_img,$(src)))
# Local files (images, photos) embedded in a post
post_files = $(shell _pandoc/post-files.sh _posts/$(1).md)

define remote_image_rule
$(IMG_DIR)/$(call img_name,$(1)).img:
	mkdir -p $$(@D)
	curl -fsSL '$(1)' -o '$$@.download'
	mv '$$@.download' '$$@'
endef

$(foreach src,$(sort $(foreach post,$(ARTICLES) $(LETTERS),$(call post_image_srcs,_posts/$(post).md))),\
	$(if $(call is_remote,$(src)),$(eval $(call remote_image_rule,$(src)))))

# The fonts of the PDFs are downloaded rather than kept in the repository
FONTS_DIR := _build/fonts
$(FONTS_DIR)/.stamp: _pandoc/fetch-fonts.sh
	_pandoc/fetch-fonts.sh $(FONTS_DIR)
	@touch $@

# PDF of a post: pandoc turns the post into Typst through the filter and the template of its layout, then
# Typst compiles it (with the fonts downloaded in FONTS_DIR only). Site-relative links are made absolute with SITE_URL.
# A PDF is rebuilt only when the content of its post, of its layout, or of the files it embeds changes (not on
# timestamps, which are meaningless after a git checkout): _build/hash/<post>.sha always re-checks the content
# hash but is only rewritten when it changes. Remote images are order-only prerequisites: fetched when missing,
# never a trigger.
# $(1) = post name, $(2) = layout (article or letter)
define pdf_rule
_build/hash/$(1).sha: FORCE
	@mkdir -p $$(@D)
	@new=$$$$(cat _posts/$(1).md _pandoc/$(2).lua _pandoc/$(2).typ _pandoc/common.lua _pandoc/common.typ _pandoc/preprocess.sed $(call post_files,$(1)) | shasum -a 256 | cut -d' ' -f1); \
	[ "$$$$(cat $$@ 2>/dev/null)" = "$$$$new" ] || echo "$$$$new" > $$@

assets/posts/pdfs/$(1).pdf: _build/hash/$(1).sha $(FONTS_DIR)/.stamp | $(call post_images,_posts/$(1).md)
	@mkdir -p $$(@D)
	$(PREPROCESS) _posts/$(1).md | pandoc -f markdown-markdown_in_html_blocks -t typst \
		--template _pandoc/$(2).typ -L _pandoc/$(2).lua \
		-M date="$(call post_date,$(1))" -M site_url="$(SITE_URL)" \
		| typst compile --root . --font-path $(FONTS_DIR) --ignore-system-fonts - $$@
endef
$(foreach post,$(ARTICLES),$(eval $(call pdf_rule,$(post),article)))
$(foreach post,$(LETTERS),$(eval $(call pdf_rule,$(post),letter)))
