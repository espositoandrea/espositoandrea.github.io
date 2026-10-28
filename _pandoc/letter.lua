-- Pandoc filter: Markdown letter -> blocked letter (template: letter.typ).
-- Front matter: author, opening, to (one address line per line), date.
-- The last paragraph of the body is used as the complimentary close.
-- Figures (<figure> or ![caption](url)) are figures (see common.lua).

local stringify = pandoc.utils.stringify

-- shared helpers live next to this script
package.path = PANDOC_SCRIPT_FILE:match('^(.*)/[^/]*$') .. '/?.lua;' .. package.path
local common = require('common')

return common.pipeline{
  Pandoc = function(doc)
    local meta = doc.meta
    meta.site_host = pandoc.MetaInlines{pandoc.Str((common.site_url:gsub('^https?://', ''):gsub('/$', '')))}
    local body = pandoc.List(doc.blocks)
    if #body > 0 and body[#body].t == 'Para' then
      meta.closing = pandoc.MetaInlines(body[#body].content)
      body:remove(#body)
      doc.blocks = body
    end

    -- the inside address: one line each, web addresses as links
    if meta.to then
      local address = pandoc.Inlines{}
      for _, line in ipairs(common.lines(meta.to)) do
        if line ~= '' then
          if #address > 0 then address:insert(pandoc.LineBreak()) end
          address:insert(line:match('^https?://') and pandoc.Link(line, line) or pandoc.Str(line))
        end
      end
      meta.address = pandoc.MetaInlines(address)
    end
    return doc
  end,
}
