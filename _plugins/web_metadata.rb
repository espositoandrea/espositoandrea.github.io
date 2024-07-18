# frozen_string_literals: true

require "nokogiri"
require "open-uri"

module Jekyll
  module WebMetadata
    def photo_from_url(input)
      MetadataParser.get_opengraph_image(input)
    end
  end
end

Liquid::Template.register_filter(Jekyll::WebMetadata)
