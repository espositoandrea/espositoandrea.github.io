# frozen_string_literals: true

module Jekyll
  module BibliographyEditor
    @@acm_dl_icon = '<img src="https://upload.wikimedia.org/wikipedia/commons/8/8e/Association_for_Computing_Machinery_%28ACM%29_logo.svg" height=20 style="vertical-align: text-bottom;" alt="ACM Digital Library"/>'
    @@springer_sharedit_icon = '<img src="https://sustainabilitycommunity.springernature.com/theme/assets/touch-icon.png?cache_key=7bfc29ef095294ef138877ebd9634c02a4b7d4a6&theme=nature-sustainability" height=20 style="vertical-align: text-bottom;" alt="Springer Nature SharedIt"/>'
    @@openaccess_icon = '<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Open_Access_logo_PLoS_transparent.svg/1024px-Open_Access_logo_PLoS_transparent.svg.png" height=20 style="vertical-align: text-bottom;" alt="Open Access"/>'
    @@arxiv_icon = '<img src="https://public.boxcloud.com/api/2.0/files/804102562135/content?preview=true&version=860286523735&access_token=1!dH6BPJK0RJFxLTFN5RcZH6UDBAccQeHNa45p98NXxXXhmHcgZ_66BPCW2lJ4ZpKEm0xkwEflyLh2J5MrnXGcKOYi_mua624XUgotH8JOXv0Zd7atpGlePHgQOb27s41zcf_UABA3DOIWp3Cdj0iQtavRHQV7U2nh9bumaGVcbQp-d2lQBGH_g50yNOG4IO6Zk9B7sZKgUjfQt0g3nCd5zclLoElej2cBslNkDDBf6TKk7ugzUv_0oYD4aRUruSz9dLfg3VHEXLa3Dg1B1h7A5JCPQOmybBEeCLC_MxvTCd_leGm-sQtvK09UoEo7UhGdT4H36QyQEisLo0ANfaSU8GNXtL7BWNZxLRvjJE4bNhEYSftwzF-PLhWWCb-CUuCZ6ltGF6z_kujZ3QEiINgYzOR2LDmpce_vZue_SXXj5RkFyPtIVTfBjtlqfwpqjKpVdP_7rNiH9zWNP5RIo2premiWuNEQ4hMAaZrcW8UQa47FgXzn7jD33eZ6LS4H6Zv03cU0Vr2aKYVtTR4NvUjhEX5ZgAD-38r_KLYpxcqoAeIGqfhI_XUWCqb4gEwhTjE.&shared_link=https%3A%2F%2Fcornell.app.box.com%2Fv%2Farxiv-logomark-small-svg&box_client_name=box-content-preview&box_client_version=2.102.0" height=20 style="vertical-align: text-bottom;" alt="Preprint available on arXiv"/>'
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
