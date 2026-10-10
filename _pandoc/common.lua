-- Helpers shared by the groff MM writers (article.lua, letter.lua)

local stringify = pandoc.utils.stringify
local M = {}

function M.esc(s)
  s = s:gsub('\\', '\\e'):gsub('\u{00A0}', '\\~')
  -- a leading "." or "'" would be read as a roff request
  if s:match("^[.']") then s = '\\&' .. s end
  return s
end

function M.q(s) return '"' .. s:gsub('"', '""') .. '"' end

-- Site root used to turn site-relative links into absolute URLs (set by the writers from `site_url`)
M.site_url = ''

-- Links in a PDF must be absolute: site-relative targets ("/assets/x.pdf", "assets/x.pdf") get the site URL
function M.link_target(target)
  if target:match('^[%a][%w+.-]*:') or target:match('^#') or M.site_url == '' then return target end
  return M.site_url:gsub('/$', '') .. '/' .. target:gsub('^/', '')
end

-- File printed for an image: remote and local raster images go through _build/images/<name>.pdf, which
-- the Makefile creates (download + conversion); a local PDF is used as it is.
-- Must match the naming used by the Makefile (img_name): last path segment, sanitised, no extension.
function M.print_image(src)
  local remote = src:match('^https?://')
  if not remote and src:match('%.[pP][dD][fF]$') then return (src:gsub('^/', '')) end
  local name = src:match('([^/]*)$'):gsub('[^%w._-]', '_'):gsub('%.[^.]*$', '')
  return '_build/images/' .. name .. '.pdf'
end

-- .pdfinfo lines setting CreationDate and ModDate to the post's publishing date (YYYY-MM-DD, midnight UTC)
function M.pdf_dates(date)
  local y, m, d = tostring(date or ''):match('^(%d%d%d%d)-(%d%d)-(%d%d)')
  if not y then return '' end
  local stamp = M.q('D:' .. y .. m .. d .. '000000Z')
  return '.pdfinfo /CreationDate ' .. stamp .. '\n.pdfinfo /ModDate ' .. stamp .. '\n'
end

-- A floating figure (.DF) from a Figure block or a parsed <figure> element
function M.figure(el)
  local img
  el:walk{Image = function(i) img = img or i end}
  if not img then return '' end
  local caption = el.t == 'Figure' and stringify(el.caption.long) or nil
  return '.DF\n.PDFPIC -C ' .. M.q(M.print_image(img.src)) .. '\n' ..
         (caption and ('.FG ' .. M.q(caption) .. '\n') or '') .. '.DE\n'
end

-- Render a raw HTML block (e.g. <figure>) by parsing it and handing its blocks to `block`
function M.html_block(el, block)
  local out = {}
  for _, b in ipairs(pandoc.read(el.text, 'html').blocks) do
    out[#out + 1] = b.t == 'Figure' and M.figure(b) or block(b)
  end
  return table.concat(out)
end

return M
