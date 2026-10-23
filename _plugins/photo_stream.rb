# frozen_string_literal: true

require 'time'

module Jekyll
  # Collects every photograph of the site into `site.data['photo_stream']`, newest first, for
  # the photography page and the home page. Sources (see _data/photography.yml):
  # - _data/photography.yml: standalone photos, often also posted on Instagram;
  # - posts with a `photos` list in the front matter;
  # - posts in the "Photography" category without such a list, through their cover `image`.
  #
  # Each photo is a hash with: src, alt, title, caption, location, exif, camera, date, source
  # ("blog", "instagram" or "site"), url (where the photo is published), url_label, external,
  # instagram, post_title, post_url and anchor (for photos of posts), and embed (true for Instagram posts without a local image, shown
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

    # Photos of a post link to their place in it: `photo-<id>`, or `photo-<n>` (1-based) for
    # photos without an id (see _includes/photo.html). A cover image links to the post.
    # The cover of a post can carry its own photo details, in the post's front matter: `exif`
    # (or `camera`), `location`, and `image_caption`. Photo posts (see _layouts/post.html) are
    # made of the cover only.
    def from_post(post)
      summary = exif_summary(exif(post.data))
      post.data['cover_camera_summary'] = summary if post.data['image'] && summary

      list = post.data['photos']
      cover = list.nil? || list.empty?
      if cover
        categories = Array(post.data['categories']).map { |c| c.to_s.downcase }
        return [] unless categories.include?(CATEGORY) && post.data['image']

        list = [{
          'src' => post.data['image'], 'alt' => post.data['image_alt'], 'caption' => post.data['image_caption'],
          'title' => post.data['title'], 'location' => post.data['location'], 'exif' => post.data['exif'],
          'camera' => post.data['camera'], 'date' => post.data['photo_date']
        }]
      end

      Array(list).each_with_index.filter_map do |entry, index|
        entry = { 'src' => entry } if entry.is_a?(String)
        src = entry['src'] || entry['image']
        next if src.nil?

        anchor = cover ? nil : (entry['id'] || index + 1).to_s
        enrich_post_photo(entry, src, anchor) unless cover
        photo(entry, src).merge(
          'date' => entry['date'] || post.date,
          'source' => 'blog',
          'url' => anchor ? "#{post.url}#photo-#{anchor}" : post.url,
          'post_url' => post.url,
          'anchor' => anchor,
          'url_label' => "From “#{post.data['title']}”",
          'external' => false,
          'post_title' => post.data['title'],
          'embed' => false
        )
      end
    end

    # Completes a photo of the post's own `photos` list for _includes/photo.html, which places
    # it in the text: its anchor, its file, and the one-line exif summary.
    def enrich_post_photo(entry, src, anchor)
      entry['anchor'] = anchor
      entry['src'] = src
      entry['camera_summary'] = exif_summary(exif(entry))
    end

    def photo(entry, src)
      {
        'src' => src,
        'alt' => entry['alt'].to_s,
        'title' => entry['title'],
        'caption' => entry['caption'],
        'location' => entry['location'],
        'exif' => exif(entry),
        'camera' => exif_summary(exif(entry)),
        'date' => entry['date'],
        'instagram' => entry['instagram']
      }
    end

    # Structured `exif` hash (camera, lens, focal_length, aperture, shutter_speed, iso); a
    # plain `camera` string is still accepted.
    def exif(entry)
      data = entry['exif']
      data = {} unless data.is_a?(Hash)
      data = { 'camera' => entry['camera'] }.merge(data) if entry['camera']
      data.compact
    end

    # One-line version of the exif data, e.g. "Fujifilm X100V · 23mm f/2 · 1/250s · ISO 400".
    def exif_summary(data)
      return nil if data.empty?

      focal = data['focal_length'] && "#{data['focal_length']}mm"
      aperture = data['aperture'] && "f/#{data['aperture']}"
      shutter = data['shutter_speed'] && "#{data['shutter_speed']}s"
      iso = data['iso'] && "ISO #{data['iso']}"
      lens = data['lens'] || [focal, aperture].compact.join(' ')
      settings = data['lens'] ? [focal, aperture] : []
      [data['camera'], lens, *settings, shutter, iso].map(&:to_s).reject(&:empty?).uniq.join(' · ')
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
