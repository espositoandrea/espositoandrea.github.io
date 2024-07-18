# frozen_string_literal: true

module MetadataParser
  # @param [String] url The Medium URL of which to get the publication name
  # @return [String] The publication name
  def self.get_medium_publication(url)
    content = Nokogiri::HTML(URI.open(url))
    # @type [Array[String]]
    s = content.title.split('|')
    unless s.empty?
      if s.last.strip == "Medium" then "Medium" else "#{s.last.strip} (Medium)" end
    end
  end

  # @param [String] url The URL of which to get the description
  # @return [String] The page description
  def self.get_description(url)
    content = Nokogiri::HTML(URI.open(url))
    description = ""
    if !content.css("meta[name='description']").blank?
      description = content.css("meta[name='description']").first.attributes["content"]
    elsif !content.css("meta[property='og:description']").blank?
      description = content.css("meta[property='og:description']").first.attributes["content"]
    end
    description
  end

  # @param [String] url The URL of which to get the OpenGraph image
  # @return [String] The URL to the OpenGraph image
  def self.get_opengraph_image(url)
    content = Nokogiri::HTML(URI.open(url))
    if !content.css("meta[property='og:image']").blank?
      photo_url = content.css("meta[property='og:image']").first.attributes["content"]
      URI.join(url, photo_url).to_str
    elsif !content.css("link[rel*=icon]").blank?
      photo_url = content.css("link[rel*=icon]").first.attributes["href"]
      URI.join(url, photo_url).to_str
    end
  end
end
