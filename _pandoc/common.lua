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

-- Must match the naming used by the Makefile (img_name): last URL segment, sanitised, no extension.
-- Remote images are printed from _build/images/<name>.pdf, which the Makefile downloads and converts.
function M.print_image(src)
  if not src:match('^https?://') then return (src:gsub('^/', '')) end
  local name = src:match('([^/]*)$'):gsub('[^%w._-]', '_'):gsub('%.[^.]*$', '')
  return '_build/images/' .. name .. '.pdf'
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
