#!/bin/sh
# Usage: image-to-pdf.sh INPUT OUTPUT
# Convert a raster image (png, jpg, webp, ...) to a one-page PDF: with sips on macOS, otherwise with Pillow.
set -e
if command -v sips >/dev/null 2>&1; then
  sips -s format pdf "$1" --out "$2" >/dev/null
else
  python3 - "$1" "$2" <<'PY'
import sys
from PIL import Image
img = Image.open(sys.argv[1])
if img.mode in ("RGBA", "LA", "P"):
    img = img.convert("RGBA")
    flat = Image.new("RGB", img.size, "white")
    flat.paste(img, mask=img.split()[-1])
    img = flat
else:
    img = img.convert("RGB")
img.save(sys.argv[2], "PDF")
PY
fi
