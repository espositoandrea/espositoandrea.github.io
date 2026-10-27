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


local function sub(list, from, to)
  local out = pandoc.List()
  for i = from, to do out:insert(list[i]) end
  return out
end

-- A block quote whose last line is a credit ("— Name"): a Typst quote with an attribution
local function attributed_quote(quote)
  local last = quote.content[#quote.content]
  if not last or (last.t ~= 'Para' and last.t ~= 'Plain') then return end
  local inlines = last.content
  local dash
  for i = #inlines, 2, -1 do
    local el, before = inlines[i], inlines[i - 1]
    if el.t == 'Str' and el.text:sub(1, 3) == '\u{2014}' and (before.t == 'SoftBreak' or before.t == 'LineBreak') then
      dash = i
      break
    end
  end
  if not dash then return end

  -- the credit, without the dash and the trailing breaks
  local credit = pandoc.Inlines(sub(inlines, dash, #inlines))
  local first = credit[1]
  first.text = first.text:sub(4)
  if first.text == '' then credit:remove(1) end
  while credit[1] and credit[1].t == 'Space' do credit:remove(1) end
  while credit[#credit] and (credit[#credit].t == 'LineBreak' or credit[#credit].t == 'SoftBreak' or credit[#credit].t == 'Space') do
    credit:remove(#credit)
  end

  -- the quote itself
  local body = pandoc.Blocks(sub(quote.content, 1, #quote.content - 1))
  local text = pandoc.Inlines(sub(inlines, 1, dash - 1))
  while text[#text] and (text[#text].t == 'LineBreak' or text[#text].t == 'SoftBreak' or text[#text].t == 'Space') do
    text:remove(#text)
  end
  if #text > 0 then body:insert(pandoc.Para(text)) end

  local function typst(blocks)
    blocks = pandoc.Pandoc(blocks):walk{Link = function(link)
      link.target = common.link_target(link.target)
      return link
    end}
    return (pandoc.write(blocks, 'typst'):gsub('%s+$', ''))
  end
  return pandoc.RawBlock('typst', '#quote(block: true, attribution: [' .. typst{pandoc.Plain(credit)} .. '])[\n' ..
                                  typst(body) .. '\n]')
end

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

    return doc:walk{
      Header = function(h)
        h.level = math.max(h.level - 1, 1)
        return h
      end,
      BlockQuote = attributed_quote,
    }
  end,
}
