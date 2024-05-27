# frozen_string_literals: true

require "nokogiri"
require "open-uri"

module Jekyll
  module WebMetadata
    def photo_from_url(input)
      content = Nokogiri::HTML(URI.open(input))
      if !content.css("meta[property='og:image']").blank?
        photo_url = content.css("meta[property='og:image']").first.attributes["content"]
        URI.join(input, photo_url).to_str
      elsif !content.css("link[rel*=icon]").blank?
        photo_url = content.css("link[rel*=icon]").first.attributes["href"]
        URI.join(input, photo_url).to_str
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::WebMetadata)
