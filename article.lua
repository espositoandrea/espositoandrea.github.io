-- Pandoc custom writer: Markdown post -> GNU groff MM article (two columns, PDF outline, footnotes).
--
-- Front matter used: title, author, date, institution (one line per line), excerpt (abstract).
-- Body conventions:
--   * "## Heading" becomes a level-1 heading (and a PDF bookmark).
--   * The blocks after the last horizontal rule (the cross-post notice) go in a box at the end.
--   * <figure><img data-print-src="path.pdf"><figcaption>..</figcaption></figure> becomes a floating
--     figure; the image printed is the local PDF named by data-print-src.

local stringify = pandoc.utils.stringify

local function esc(s)
  s = s:gsub('\\', '\\e'):gsub('\u{00A0}', '\\~')
  -- a leading "." or "'" would be read as a roff request
  if s:match("^[.']") then s = '\\&' .. s end
  return s
end

local function q(s) return '"' .. s:gsub('"', '""') .. '"' end

local inlines, blocks

-- Split trailing punctuation off the Str that follows a link so that it can be glued to it (-A)
local function trailing_punct(next_el)
  if next_el and next_el.t == 'Str' then
    local punct = next_el.text:match('^[%.,;:!%?%)]+')
    if punct then
      next_el.text = next_el.text:sub(#punct + 1)
      return punct
    end
  end
end

function inlines(list)
  local out = {}
  for i, el in ipairs(list) do
    local t = el.t
    local prev, nxt = list[i - 1], list[i + 1]
    local s
    if t == 'Str' then s = esc(el.text)
    elseif t == 'Space' then
      -- a link macro sits on its own line, so the line break already acts as the space
      local after_link = prev and (prev.t == 'Link' or (prev.t == 'Str' and prev.text == '' and list[i - 2] and list[i - 2].t == 'Link'))
      local adjacent = (nxt and nxt.t == 'Link') or after_link
      s = adjacent and '' or ' '
    elseif t == 'SoftBreak' then s = '\n'
    elseif t == 'LineBreak' then s = '\n.br\n'
    elseif t == 'Emph' then s = '\\fI' .. inlines(el.content) .. '\\fP'
    elseif t == 'Strong' then s = '\\fB' .. inlines(el.content) .. '\\fP'
    elseif t == 'Code' then s = '\\f[CR]' .. esc(el.text) .. '\\f[P]'
    elseif t == 'Quoted' then
      local l, r = '\u{201C}', '\u{201D}'
      if el.quotetype == 'SingleQuote' then l, r = '\u{2018}', '\u{2019}' end
      s = l .. inlines(el.content) .. r
    elseif t == 'Link' then
      local after = trailing_punct(nxt)
      local glue = (prev and prev.t ~= 'Space' and prev.t ~= 'SoftBreak') and '\\c' or ''
      s = glue .. '\n.pdfhref W -D ' .. q(el.target) .. (after and (' -A ' .. q(after)) or '') ..
          ' -- ' .. q(stringify(el.content)) .. '\n'
    elseif t == 'Note' then
      local paras = {}
      for _, b in ipairs(el.content) do
        paras[#paras + 1] = inlines(b.content or pandoc.Inlines{pandoc.Str(stringify(b))})
      end
      s = '\\*F\\c\n.FS\n' .. (table.concat(paras, '\n.sp\n'):gsub('\n+$', '')) .. '\n.FE\n'
    elseif t == 'Span' or t == 'SmallCaps' or t == 'Underline' then s = inlines(el.content)
    else s = esc(stringify(el)) end
    out[#out + 1] = s
  end
  return table.concat(out)
end

local function lines(meta)
  -- split a multi-line metadata value on its line breaks
  local out, cur = {}, {}
  local content = pandoc.utils.type(meta) == 'Inlines' and meta or pandoc.utils.blocks_to_inlines(meta)
  for _, el in ipairs(content) do
    if el.t == 'SoftBreak' or el.t == 'LineBreak' then
      out[#out + 1] = stringify(pandoc.Inlines(cur)); cur = {}
    else cur[#cur + 1] = el end
  end
  out[#out + 1] = stringify(pandoc.Inlines(cur))
  return out
end

local function long_date(s)
  local y, m, d = tostring(s):match('^(%d+)-(%d+)-(%d+)')
  if not y then return tostring(s) end
  return (os.date('%b %d, %Y', os.time{year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 12}):gsub(' 0', ' '))
end

local function figure(el)
  local img
  el:walk{Image = function(i) img = img or i end}
  if not img then return '' end
  local src = img.attributes['data-print-src'] or img.attributes['print-src']
  if not src then
    io.stderr:write('article.lua: figure without data-print-src: ' .. img.src .. '\n')
    return ''
  end
  local caption = el.t == 'Figure' and stringify(el.caption.long) or nil
  return '.DF\n.PDFPIC -C ' .. q(src) .. '\n' ..
         (caption and ('.FG ' .. q(caption) .. '\n') or '') .. '.DE\n'
end

local block

local function list_items(items)
  local out = {}
  for _, item in ipairs(items) do
    out[#out + 1] = '.LI\n' .. (blocks(item):gsub('^%.P\n', ''))
  end
  return table.concat(out)
end

function block(el)
  local t = el.t
  if t == 'Para' or t == 'Plain' then return '.P\n' .. inlines(el.content) .. '\n'
  elseif t == 'Header' then
    local title = stringify(el.content)
    local lvl = math.max(el.level - 1, 1)
    return '.H ' .. lvl .. ' ' .. q(title) .. '\n.pdfhref O ' .. lvl .. ' ' .. q(title) ..
           '\n.pdfhref M ' .. q(el.identifier) .. '\n'
  elseif t == 'OrderedList' then return '.AL\n' .. list_items(el.content) .. '.LE\n'
  elseif t == 'BulletList' then return '.BL\n' .. list_items(el.content) .. '.LE\n'
  elseif t == 'BlockQuote' then return '.DS I\n' .. blocks(el.content) .. '.DE\n'
  elseif t == 'RawBlock' and el.format == 'html' then
    local out = {}
    for _, b in ipairs(pandoc.read(el.text, 'html').blocks) do
      out[#out + 1] = b.t == 'Figure' and figure(b) or block(b)
    end
    return table.concat(out)
  elseif t == 'Figure' then return figure(el)
  elseif t == 'HorizontalRule' then return ''
  else return '.P\n' .. esc(stringify(el)) .. '\n' end
end

function blocks(list)
  local out = {}
  for _, el in ipairs(list) do out[#out + 1] = block(el) end
  return table.concat(out)
end

function Writer(doc, opts)
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

  local title = stringify(meta.title or '')
  local author = meta.author and stringify(meta.author) or ''
  local year = meta.date and stringify(meta.date):match('^%d+') or os.date('%Y')
  -- "Andrea Esposito" -> "Esposito A."
  local last, initial = author:match('(%S+)$'), author:match('^(%S)')
  local short_author = (last and initial) and (last .. ' ' .. initial .. '.') or author

  local out = {}
  local function add(s) out[#out + 1] = s end
  add('.\\" Generated by article.lua; compile with groff -U -k -Tpdf -mm -mpdfpic\n')
  add('.PF "\'\'- % -\'\'"\n')
  add('.PH ' .. q("'" .. short_author .. "''" .. (title:match('^[^:]+') or title) .. "'") .. '\n')
  add('.nr N 2\n.ds HF "3 3 2 2 2 2 2"\n')
  add('.ds PDFHREF.COLOUR 0.35 0.00 0.60\n.ds PDFHREF.BORDER 0 0 0\n')
  add('.nr PDFOUTLINE.FOLDLEVEL 3\n.pdfview /PageMode /UseOutlines\n')
  add('.pdfinfo /Title ' .. q(title) .. '\n.pdfinfo /Author ' .. q(author) .. '\n')
  add('.TL\n' .. esc(title) .. '\n')
  if meta.institution then
    local inst = lines(meta.institution)
    -- keep the university and department, drop the street address
    add('.AF ' .. q(inst[2] .. ', ' .. inst[1]) .. '\n')
  end
  add('.AU ' .. q(author) .. '\n')
  if meta.date then add('.ND ' .. q(long_date(stringify(meta.date))) .. '\n') end
  if meta.excerpt then
    -- the abstract has no room for footnote marks
    local abstract = stringify(meta.excerpt)
    for _, mark in ipairs{'\u{00B9}', '\u{00B2}', '\u{00B3}', '\u{2074}', '\u{2075}', '\u{2076}',
                          '\u{2077}', '\u{2078}', '\u{2079}', '\u{2070}'} do
      abstract = abstract:gsub(mark, '')
    end
    add('.AS 0\n' .. esc(abstract) .. '\n.AE\n')
  end
  add('.MT 4\n.2C\n')
  if #notice > 0 then
    add('.BS\n.1C\n\\l\'12\'\n.br\n.sp -0.25\n.ps -2\n')
    add('Copyright \\[co] ' .. year .. ' held by the Author\n')
    add((blocks(notice):gsub('^%.P\n', '.br\n')))
    add('.2C\n.BE\n')
  end
  add(blocks(body))
  return table.concat(out)
end
