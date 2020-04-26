# frozen_string_literals: true

require "kramdown"
require "nokogiri"

class Jekyll::Converters::Markdown::MyMarkdownProcessor
  def initialize(config)
    @config = config
  end

  def convert(content)
    doc = Nokogiri::HTML::Document.parse ::Kramdown::Document.new(content, @config).to_html

    blockquotes = doc.css "blockquote"
    blockquotes.each do |blockquote|
      blockquote["class"] = "#{blockquote["class"]} blockquote"
      footer = blockquote.>("p").last
      if !footer.nil? && match = footer.content.match(/^(?:&ndash;|–)\s(.*?)$/)
        footer.name = "footer"
        footer.content = match.captures[0]
        footer["class"] = "#{footer["class"]} blockquote-footer"
      end
    end

    doc.to_html
  end
end
