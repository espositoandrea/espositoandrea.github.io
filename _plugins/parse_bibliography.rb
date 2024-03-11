# frozen_string_literals: true

module Jekyll
  module BibliographyEditor
    @@acm_dl_icon = '<i class="ai ai-acm" aria-label="ACM Digital Library"></i>'
    @@springer_sharedit_icon = '<i class="ai ai-springer" aria-label="Springer Nature SharedIt"></i>'
    @@openaccess_icon = '<i class="ai ai-open-access" aria-label="Open Access icon"></i>'
    @@arxiv_icon = '<i class="ai ai-arxiv" aria-label="Preprint available on arXiv"></i>'
    @@pdf_icon = '<i class="fas fa-file-pdf" aria-label="self-archived PDF"></i>'

    # @param [String] input
    # @return String
    def edit_urls(input)
      input.split("\n").map { |line|
        line.gsub(%r{(https?://doi.org/.*?), Retrieved from \1</span>}, '\1</span>')
            .gsub(%r{https?://doi.org/(.*?)(</span>|, Retrieved)}, '<a href="https://doi.org/\1" target="_blank">\1</a>\2')
            .sub(%r{https?://((?!rdcu.be|arxiv|ceur|doi|dl.acm.org|link.springer.com|(?:www.)?dropbox.com|(?:www.)?scitepress.org).*?)</span>}, 'URL: <a href="https://\1" target="_blank">\1</a></span>')
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
            .sub(%r{(<i>Scientific Reports</i>.*?), Retrieved from (.*?)</span>}, "\\1 <a title=\"Access full paper\" href=\"\\2\" target=\"_blank\">#{@@openaccess_icon}</a></span>")
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
