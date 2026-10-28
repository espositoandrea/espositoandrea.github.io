-- Helpers shared by the Typst layouts (article.lua, letter.lua, photo.lua).
--
-- Each layout is a pandoc Lua filter (run with -L) that reshapes the document for its template
-- (<layout>.typ); pandoc's own Typst writer does the rest. A layout returns `common.pipeline(layout)`:
--   1. site_url is read from the metadata;
--   2. raw HTML blocks (<figure>...) are parsed into native blocks;
--   3. the layout's own filter runs (a table of handlers, or a Pandoc function);
--   4. image sources and link targets are made printable;
--   5. the metadata shared by all templates (t_title, t_author, t_date, date_long, year) is set.

local stringify = pandoc.utils.stringify
local M = {}

-- Site root used to turn site-relative links into absolute URLs (set from `site_url`)
M.site_url = ''

local MONTHS = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September',
                'October', 'November', 'December'}

-- Typst string literal
function M.tstr(s)
  s = s:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n')
  return '"' .. s .. '"'
end

-- Metadata value holding Typst code, for template variables used in code (not markup) context
function M.code(typst)
  return pandoc.MetaInlines{pandoc.RawInline('typst', typst)}
end

-- 2026-10-24 (or 2026-10-24 17:04:05) -> 2026, 10, 24
function M.parse_date(s)
  local y, m, d = tostring(s or ''):match('^(%d%d%d%d)-(%d%d)-(%d%d)')
  if y then return tonumber(y), tonumber(m), tonumber(d) end
end

-- "October 24, 2026"
function M.long_date(s)
  local y, m, d = M.parse_date(s)
  if not y then return tostring(s or '') end
  return MONTHS[m] .. ' ' .. d .. ', ' .. y
end

-- The URL of a post of this site, from the name of its source file in _posts/ (see `permalink` in _config.yml)
local function post_url(path)
  local y, m, slug = path:match('^/?_posts/(%d%d%d%d)-(%d%d)-%d%d-(.+)%.md$')
  if y then return '/blog/posts/' .. y .. '/' .. m .. '/' .. slug .. '.html' end
end

-- Links in a PDF must be absolute: site-relative targets ("/assets/x.pdf", "assets/x.pdf") get the site URL
function M.link_target(target)
  if target:match('^[%a][%w+.-]*:') or target:match('^#') or M.site_url == '' then return target end
  target = post_url(target) or target
  return M.site_url:gsub('/$', '') .. '/' .. target:gsub('^/', '')
end

-- File used for an image, as a path inside the Typst project root (the site). Remote images are downloaded by
-- the Makefile to _build/images/<name>.img (Typst recognises the format from the content); the name must match
-- img_name in the Makefile: last path segment, sanitised, no extension.
function M.print_image(src)
  if src:match('^https?://') then
    local name = src:match('([^/]*)$'):gsub('[^%w._-]', '_'):gsub('%.[^.]*$', '')
    return '/_build/images/' .. name .. '.img'
  end
  return '/' .. src:gsub('^/', '')
end

-- Lines of a multi-line metadata value (a YAML block scalar), as plain strings
function M.lines(meta)
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

local function run(filter, doc)
  if filter.Pandoc then return filter.Pandoc(doc) or doc end
  return doc:walk(filter)
end

function M.pipeline(layout)
  local steps = {
    function(doc)
      M.site_url = doc.meta.site_url and stringify(doc.meta.site_url) or ''
      return doc
    end,
    -- <figure><img src=URL><figcaption>..</figcaption></figure> and the like
    function(doc)
      return doc:walk{RawBlock = function(el)
        if el.format == 'html' then return pandoc.read(el.text, 'html').blocks end
      end}
    end,
    function(doc) return run(layout, doc) end,
    function(doc)
      return doc:walk{
        Image = function(img)
          if not img.src:match('^photo:') then
            img.src = M.print_image(img.src)
            return img
          end
        end,
        Link = function(link)
          link.target = M.link_target(link.target)
          return link
        end,
      }
    end,
    function(doc)
      local meta = doc.meta
      local title = stringify(meta.title or '')
      local author = meta.author and stringify(meta.author) or ''
      local date = meta.date and stringify(meta.date) or nil
      local y, m, d = M.parse_date(date)
      meta.t_title = M.code(M.tstr(title))
      meta.t_author = M.code(M.tstr(author))
      meta.t_date = M.code(y and ('datetime(year: %d, month: %d, day: %d)'):format(y, m, d) or 'none')
      meta.date_long = pandoc.MetaInlines{pandoc.Str(M.long_date(date))}
      meta.year = pandoc.MetaInlines{pandoc.Str(y and tostring(y) or os.date('%Y'))}
      return doc
    end,
  }
  return {{Pandoc = function(doc)
    for _, step in ipairs(steps) do doc = step(doc) end
    return doc
  end}}
end

return M
