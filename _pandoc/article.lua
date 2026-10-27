-- Pandoc filter: Markdown post -> two-column article (template: article.typ).
--
-- Front matter used: title, author, date, institution (one line per line), excerpt (abstract).
-- Body conventions:
--   * "## Heading" becomes a level-1 heading (and a PDF bookmark).
--   * The blocks after the last horizontal rule (the cross-post notice) go in a box on the first page.
--   * <figure><img src=URL><figcaption>..</figcaption></figure> becomes a figure (see common.lua).
--   * `bibliography: file.bib` (in _bibliography/): {% cite key %} became [@key], listed at the end.

local stringify = pandoc.utils.stringify

-- shared helpers live next to this script
package.path = PANDOC_SCRIPT_FILE:match('^(.*)/[^/]*$') .. '/?.lua;' .. package.path
local common = require('common')

-- superscript digits used as footnote marks in the excerpt
local MARKS = {'\u{00B9}', '\u{00B2}', '\u{00B3}', '\u{2074}', '\u{2075}', '\u{2076}', '\u{2077}', '\u{2078}',
               '\u{2079}', '\u{2070}'}

return common.pipeline{
  Pandoc = function(doc)
    local meta = doc.meta
    local body = pandoc.List(doc.blocks)

    -- the blocks after the last horizontal rule are the cross-post notice
    local notice = pandoc.List()
    if #body > 0 and body[#body].t == 'HorizontalRule' then body:remove(#body) end
    for i = #body, 1, -1 do
      if body[i].t == 'HorizontalRule' then
        for j = #body, i + 1, -1 do notice:insert(1, body:remove(j)) end
        body:remove(i)
        break
      end
    end
    if #notice > 0 then meta.notice = pandoc.MetaBlocks(notice) end
    doc.blocks = body

    if meta.institution then
      -- keep the university and department, drop the street address
      local inst = common.lines(meta.institution)
      meta.affiliation = pandoc.MetaInlines{pandoc.Str(inst[2] .. ', ' .. inst[1])}
    end

    -- references: the BibTeX file of the post, in _bibliography/ (formatted by article.typ with nature.csl)
    if meta.bibliography then
      meta.bib_path = common.code(common.tstr('/_bibliography/' .. stringify(meta.bibliography)))
    end

    if meta.excerpt then
      -- the abstract has no room for footnote marks
      local abstract = stringify(meta.excerpt)
      for _, mark in ipairs(MARKS) do abstract = abstract:gsub(mark, '') end
      meta.abstract = pandoc.MetaInlines{pandoc.Str(abstract)}
    end

    -- "Andrea Esposito" -> "Esposito A."
    local author = meta.author and stringify(meta.author) or ''
    local last, initial = author:match('(%S+)$'), author:match('^(%S)')
    meta.short_author = pandoc.MetaInlines{pandoc.Str((last and initial) and (last .. ' ' .. initial .. '.') or author)}
    meta.kicker = pandoc.MetaInlines{pandoc.Str('Essay')}
    local title = stringify(meta.title or '')
    meta.short_title = pandoc.MetaInlines{pandoc.Str(title:match('^[^:]+') or title)}

    return doc:walk{Header = function(h)
      h.level = math.max(h.level - 1, 1)
      return h
    end}
  end,
}
