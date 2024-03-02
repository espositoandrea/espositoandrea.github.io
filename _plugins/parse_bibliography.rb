# frozen_string_literals: true

module Jekyll
  module BibliographyEditor
    @@acm_dl_icon = '<img src="https://upload.wikimedia.org/wikipedia/commons/8/8e/Association_for_Computing_Machinery_%28ACM%29_logo.svg" height=20 style="vertical-align: text-bottom;" alt="ACM Digital Library"/>'
    @@springer_sharedit_icon = '<img src="https://sustainabilitycommunity.springernature.com/theme/assets/touch-icon.png?cache_key=7bfc29ef095294ef138877ebd9634c02a4b7d4a6&theme=nature-sustainability" height=20 style="vertical-align: text-bottom;" alt="Springer Nature SharedIt"/>'
    @@openaccess_icon = '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Open_Access_logo_PLoS_white.svg/384px-Open_Access_logo_PLoS_white.svg.png" height=20 style="vertical-align: text-bottom;" alt="Open Access"/>'
    @@arxiv_icon = '<img src="data:image/png;base64,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" height=20 style="vertical-align: text-bottom;" alt="Preprint available on arXiv"/>'
    @@pdf_icon = '<i class="fas fa-file-pdf" aria-label="self-archived PDF"></i>'

    # @param [String] input
    # @return String
    def edit_urls(input)
      input.split("\n").map { |line|
        line.gsub(%r{(https?://doi.org/.*?), Retrieved from \1</span>}, '\1</span>')
            .gsub(%r{https?://doi.org/(.*?)(</span>|, Retrieved)}, '<a href="https://doi.org/\1" target="_blank">\1</a>\2')
            .sub(%r{https?://((?!rdcu.be|arxiv|ceur|doi|dl.acm.org|(?:www.)?dropbox.com|(?:www.)?scitepress.org).*?)</span>}, 'URL: <a href="https://\1" target="_blank">\1</a></span>')
        #.sub(%r{[,.] Retrieved from (.*?)</span>}, '</span>')
      }.join "\n"
    end

    # @param [String] input
    # @return String
    def emphasize_author(input)
      input.split("\n").map { |line|
        line.gsub 'Andrea Esposito', '<strong>Andrea Esposito</strong>'
      }.join "\n"
    end

    # @param [String] input
    # @return String
    def remove_number(input)
      input.split("\n").map { |line| line.sub />\[\d+?\]/, ">" }.join "\n"
    end

    # @param [String] input
    # @return String
    def acm_authorizer(input)
      input.split("\n").map { |line|
        line.sub(%r{, Retrieved from (https://dl.acm.org/doi/.*?)</span>}, " <a title=\"Access full paper\" href=\"\\1\" target=\"_blank\">#{@@acm_dl_icon}</a></span>")
            .sub(%r{, Retrieved from (https://rdcu.be/.*?)</span>}, " <a title=\"Access full paper\" href=\"\\1\" target=\"_blank\">#{@@springer_sharedit_icon}</a></span>")
      }.join "\n"
    end

    # @param [String] input
    # @return String
    def open_access(input)
      input.split("\n").map do |line|
        line.gsub(%r{https?://ceur-ws\.org/(.*?)</span>}, "URL: <a href=\"https://ceur-ws.org/\\1\" target=\"_blank\">CEUR-WS.org/\\1 #{@@openaccess_icon}</a></span>")
            .sub(%r{, Retrieved from (https://www.scitepress.org/.*?)</span>}, " <a title=\"Access full paper\" href=\"\\1\" target=\"_blank\">#{@@openaccess_icon}</a></span>")
            .gsub(%r{https?://(www\.)?dropbox\.com/(.*?)</span>}, "URL: <a href=\"https://\\1dropbox.com/\\2\" target=\"_blank\">\\1dropbox.com/\\2 #{@@openaccess_icon}</a></span>")
      end.join "\n"
    end

    # @param [String] input
    # @return String
    def preprint(input)
      input.split("\n").map do |line|
        line.gsub %r{Retrieved from https?://arxiv.org/(.*?)</span>}, "Preprint URL: <a href=\"https://arxiv.org/\\1\" target=\"_blank\">arXiv.org/\\1 #{@@arxiv_icon}</a></span>"
      end.join "\n"
    end

    # @param [String] input
    # @return String
    def self_archived(input)
      input.split("\n").map do |line|
        line.gsub %r{Retrieved from file://papers/(.*?)</span>}, "Self-Archived PDF: <a href=\"" + absolute_url("assets/papers/$$$").sub('$$$', '\\\\1') +"\" target=\"_blank\">\\1 #{@@pdf_icon}</a></span>"
      end.join "\n"
    end
  end
end

Liquid::Template.register_filter(Jekyll::BibliographyEditor)
