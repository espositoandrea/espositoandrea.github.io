-- Pandoc filter: photo essay -> magazine-style PDF (template: photo.typ).
--
-- Front matter used: title, author, date, excerpt (standfirst), image (cover), categories, canonical_url,
-- canonical_site_name, and `photos`: the photos of the essay (id, src or image, alt, title, date, location,
-- exif...), as shown on the site by _includes/photo.html. The preprocessor (preprocess.sed) turns
-- {% include photo.html id="x" %} into ![](photo:x), which is replaced here by a #photo(...) call of the
-- template. Photos of the list that are not placed in the text are added at the end, as on the site.
-- The first paragraph of the text is set as a lead.

local stringify = pandoc.utils.stringify

-- shared helpers live next to this script
package.path = PANDOC_SCRIPT_FILE:match('^(.*)/[^/]*$') .. '/?.lua;' .. package.path
local common = require('common')
local tstr = common.tstr

local function field(map, key)
  local value = map[key]
  if value == nil then return nil end
  value = stringify(value)
  if value ~= '' then return value end
end

-- One-line version of the exif data, e.g. "Fujifilm X100V · 23mm f/2 · 1/250s · ISO 400".
-- Same as exif_summary in _plugins/photo_stream.rb.
local function exif_summary(entry)
  local data = {}
  if entry.camera then data.camera = field(entry, 'camera') end
  if entry.exif then
    for _, key in ipairs{'camera', 'lens', 'focal_length', 'aperture', 'shutter_speed', 'iso'} do
      data[key] = field(entry.exif, key) or data[key]
    end
  end
  if next(data) == nil then return '' end
  local focal = data.focal_length and (data.focal_length .. 'mm')
  local aperture = data.aperture and ('f/' .. data.aperture)
  local shutter = data.shutter_speed and (data.shutter_speed .. 's')
  local iso = data.iso and ('ISO ' .. data.iso)
  local lens = data.lens or table.concat({focal or '', aperture or ''}, ' '):gsub('^ +', ''):gsub(' +$', '')
  local parts = {data.camera, lens}
  if data.lens then
    parts[#parts + 1] = focal
    parts[#parts + 1] = aperture
  end
  parts[#parts + 1] = shutter
  parts[#parts + 1] = iso
  local out, seen = {}, {}
  for i = 1, 6 do
    local part = parts[i]
    if part and part ~= '' and not seen[part] then
      seen[part] = true
      out[#out + 1] = part
    end
  end
  return table.concat(out, ' · ')
end

local function typst_photo(entry)
  local src = field(entry, 'src') or field(entry, 'image')
  return ('(id: %s, src: %s, alt: %s, title: %s, date: %s, location: %s, exif: %s, caption: %s)'):format(
    tstr(field(entry, 'id') or ''),
    tstr(common.print_image(src)),
    tstr(field(entry, 'alt') or ''),
    tstr(field(entry, 'title') or ''),
    tstr(common.long_date(field(entry, 'date') or '')),
    tstr(field(entry, 'location') or ''),
    tstr(exif_summary(entry)),
    tstr(field(entry, 'caption') or ''))
end

return common.pipeline{
  Pandoc = function(doc)
    local meta = doc.meta
    local entries = meta.photos or pandoc.MetaList{}

    -- the photos, as a Typst array
    local typst = {}
    local index_of = {}
    for i, entry in ipairs(entries) do
      typst[i] = typst_photo(entry)
      index_of[field(entry, 'id') or tostring(i)] = i
    end
    meta.photos_typst = common.code('(' .. table.concat(typst, ', ') .. (#typst == 1 and ',' or '') .. ')')

    -- ![](photo:id) and ![](photo:#n) -> #photo(n)
    local placed = {}
    doc = doc:walk{Para = function(para)
      local img = para.content[1]
      if #para.content ~= 1 or img.t ~= 'Image' or not img.src:match('^photo:') then return end
      local ref = img.src:gsub('^photo:', '')
      local n = ref:match('^#(%d+)$')
      n = n and tonumber(n) or index_of[ref]
      if not n or not entries[n] then
        error('photo.lua: no photo "' .. ref .. '" in the photos of this post')
      end
      placed[n] = true
      local layout = img.attributes.layout or ''
      return pandoc.RawBlock('typst', ('#photo(%d, layout: %s)'):format(n, tstr(layout)))
    end}

    -- photos that the text does not place come last
    local blocks = pandoc.List(doc.blocks)
    for i = 1, #entries do
      if not placed[i] then blocks:insert(pandoc.RawBlock('typst', ('#photo(%d)'):format(i))) end
    end

    -- the first paragraph is the lead
    for i, block in ipairs(blocks) do
      if block.t == 'Para' then
        blocks:insert(i + 1, pandoc.RawBlock('typst', ']'))
        blocks:insert(i, pandoc.RawBlock('typst', '#lead['))
        break
      end
    end
    doc.blocks = blocks

    -- "## Heading" is a level-1 heading (a section opener)
    doc = doc:walk{Header = function(h)
      h.level = math.max(h.level - 1, 1)
      return h
    end}
    meta = doc.meta -- the walks above return copies
    if meta.image then meta.t_cover = common.code(tstr(common.print_image(stringify(meta.image)))) end
    local kicker = meta.categories and meta.categories[1] and stringify(meta.categories[1]) or 'Photography'
    meta.kicker = pandoc.MetaInlines{pandoc.Str(kicker)}
    if meta.canonical_url then meta.t_canonical = common.code(tstr(stringify(meta.canonical_url))) end
    local title = stringify(meta.title or '')
    meta.short_title = pandoc.MetaInlines{pandoc.Str(title)}
    return doc
  end,
}
