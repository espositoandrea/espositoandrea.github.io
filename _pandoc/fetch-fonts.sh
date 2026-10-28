#!/bin/sh
# Download the fonts of the post PDFs (Source Serif 4 and Inter, both under the SIL Open Font License) from
# their official releases into the directory given as argument, instead of vendoring them in the repository.
set -eu
dest=${1:?usage: fetch-fonts.sh <directory>}
serif_url=https://github.com/adobe-fonts/source-serif/releases/download/4.005R/source-serif-4.005_Desktop.zip
inter_url=https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL --retry 3 -o "$tmp/serif.zip" "$serif_url"
curl -fsSL --retry 3 -o "$tmp/inter.zip" "$inter_url"
unzip -q "$tmp/serif.zip" 'source-serif-4.005_Desktop/OTF/SourceSerif4*.otf' -d "$tmp/serif"
unzip -q "$tmp/inter.zip" 'extras/otf/Inter-*.otf' -d "$tmp/inter"

rm -rf "$dest"
mkdir -p "$dest"
cp "$tmp"/serif/source-serif-4.005_Desktop/OTF/*.otf "$tmp"/inter/extras/otf/Inter-*.otf "$dest"
