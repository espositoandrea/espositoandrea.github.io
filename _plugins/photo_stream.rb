# frozen_string_literal: true

require 'time'

module Jekyll
  # Collects every photograph of the site into `site.data['photo_stream']`, newest first, for
  # the photography page and the home page. Sources (see _data/photography.yml):
  # - _data/photography.yml: standalone photos, often also posted on Instagram;
  # - posts with a `photos` list in the front matter;
  # - posts in the "Photography" category without such a list, through their cover `image`.
  #
  # Each photo is a hash with: src, alt, title, caption, location, camera, date, source
  # ("blog", "instagram" or "site"), url (where the photo is published), url_label, external,
  # instagram, post_title, and embed (true for Instagram posts without a local image, shown
  # through Instagram's embed instead).
  class PhotoStream < Generator
    safe true
    priority :lowest

    CATEGORY = 'photography'

    def generate(site)
      photos = Array(site.data['photography']).map { |entry| from_data(entry) }
      site.posts.docs.each { |post| photos.concat(from_post(post)) }
      site.data['photo_stream'] = photos.compact.sort_by { |photo| -timestamp(photo['date']) }
    end

    private

    def from_data(entry)
      return nil unless entry.is_a?(Hash)

      instagram = entry['instagram']
      src = entry['image'] || entry['src']
      return nil if src.nil? && instagram.nil?

      photo(entry, src).merge(
        'source' => instagram ? 'instagram' : 'site',
        'url' => instagram,
        'url_label' => instagram ? 'View on Instagram' : nil,
        'external' => !instagram.nil?,
        'instagram' => instagram,
        'embed' => src.nil?
      )
    end

    def from_post(post)
      list = post.data['photos']
      if list.nil? || list.empty?
        categories = Array(post.data['categories']).map { |c| c.to_s.downcase }
        return [] unless categories.include?(CATEGORY) && post.data['image']

        list = [{ 'src' => post.data['image'], 'alt' => post.data['image_alt'], 'caption' => post.data['image_caption'] }]
      end

      Array(list).filter_map do |entry|
        entry = { 'src' => entry } if entry.is_a?(String)
        src = entry['src'] || entry['image']
        next if src.nil?

        photo(entry, src).merge(
          'date' => entry['date'] || post.date,
          'source' => 'blog',
          'url' => post.url,
          'url_label' => "From “#{post.data['title']}”",
          'external' => false,
          'post_title' => post.data['title'],
          'embed' => false
        )
      end
    end

    def photo(entry, src)
      {
        'src' => src,
        'alt' => entry['alt'].to_s,
        'title' => entry['title'],
        'caption' => entry['caption'],
        'location' => entry['location'],
        'camera' => entry['camera'],
        'date' => entry['date'],
        'instagram' => entry['instagram']
      }
    end

    def timestamp(date)
      case date
      when Time then date.to_i
      when Date then date.to_time.to_i
      when String then (Time.parse(date).to_i rescue 0)
      else 0
      end
    end
  end
end
