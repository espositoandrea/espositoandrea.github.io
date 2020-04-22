# frozen_string_literals: true

require 'base64'
require 'open-uri'

module Jekyll
  class ProfilePictureTag < Liquid::Tag
    def initialize(tag_name, data, tokens)
      super
    end

    def render(context)
      data = open('https://github.com/espositoandrea.png').read
      "data:image/jpg;base64,#{Base64.encode64 data}"
    end

    Liquid::Template.register_tag 'profile_pic', self
  end
end

