require "yaml"
require "htmlentities"
require "iso639"
require "bibtex"
require "time"

def translate(str, lang = "it")
  keys = YAML.load_file("../_data/_strings.yml")
  return keys[str.downcase][lang.downcase]
end

def load_skills
  skills = YAML.load_file("../_data/skills.yml")
  f = File.new("./common/cs_skills.tex", "w")
  skills.sort_by! { |skill| skill["level"] }.reverse!
  for skill in skills
    skill["name"] = "\\LaTeX" if skill["name"] == "L<sup>A</sup>T<sub>E</sub>X"
    skill["name"].gsub!(/<.*?>(.*?)<\/.*?>/, '\1')
    skill["name"] = HTMLEntities.new.decode skill["name"]
    skill["name"].gsub!("&", '\\\&')
    f.puts "\\cvtag{#{skill["name"]}}"
  end
  f.close
end

def load_languages
  languages = YAML.load_file("../_data/languages.yml")
  f = File.new("./common/languages.tex", "w")
  for language in languages
    f.puts(
      "\\DeclareTranslationFallback{#{Iso639[language[1]["name"]["en"]].alpha2}}{#{language[1]["name"]["en"]}}"
    )
    f.puts(
      "\\DeclareTranslationFallback{#{Iso639[language[1]["name"]["en"]].alpha2}-level}{#{language[1]["level"]["en"]}}"
    )
    for isoCode in language[1]["name"].keys
      next if isoCode == "original"
      f.puts(
        "\\DeclareTranslation{#{Iso639[isoCode]}}{#{Iso639[language[1]["name"]["en"]].alpha2}}{#{language[1]["name"][isoCode]}}"
      )
      f.puts(
        "\\DeclareTranslation{#{Iso639[isoCode]}}{#{Iso639[language[1]["name"]["en"]].alpha2}-level}{#{language[1]["level"][isoCode]}}"
      )
    end
    f.puts
  end
  f.close
  f = File.new("./common/sidebar_languages.tex", "w")
  i = 0
  max = languages.size
  for language in languages
    i = i + 1
    f.puts(
      "\\cvskill{\\GetTranslation{#{Iso639[language[1]["name"]["en"]].alpha2}} (\\GetTranslation{#{Iso639[language[1]["name"]["en"]].alpha2}-level})}{#{language[1]["stars"]["full"]}}"
    )
    f.puts("\\divider") unless i.equal? max
  end
  f.close
end

def load_bib
  bib = BibTeX.open("./common/bibliography.bib")
  f = File.new("../_data/publications.yml", "w")
  hash = Hash.new { |h, k| h[k] = [] }
  for entry in bib
    entry.author = entry.author.gsub(/(.*?), (.*)/, '\2 \1')
    hash[entry.type.to_s] << (entry.to_hash(:quotes => "").transform_keys! { |k| k.to_s })
  end
  f.puts hash.to_yaml
  f.close
end

def load_education
  educationSteps = YAML.load_file("../_data/education.yml")
  for language in ["it", "en"]
    f = File.new("./#{translate(Iso639[language].to_s, language).capitalize}/education.tex", "w")
    for ed in educationSteps
      beginTime = Time.parse(ed["years"]["start"])
      endTime = Time.parse(ed["years"]["end"])
      endTimeToPrint = if endTime != Time.parse("01-01-0000") then "\\monthname[#{endTime.month}] #{endTime.year}" else translate("present", language).capitalize end
      f.puts "\\cvevent{#{ed["title"][language]}}{#{ed["institute"][language]}}{\\monthname[#{beginTime.month}] #{beginTime.year} -- #{endTimeToPrint}}{#{ed["location"][language]}}"
      f.puts "#{ed["notes"][language].gsub(/<strong>(.*?)<\/strong>/, '\\textbf{\1}')}"
      f.puts("\n\\divider") unless ed.equal? educationSteps.last
      f.puts ""
    end
    f.close
  end
end

load_skills
load_languages
load_bib
load_education
