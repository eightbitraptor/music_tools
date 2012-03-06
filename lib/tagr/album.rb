# encoding: utf-8
require 'digest'

module Tagr
  class Album
    attr_reader :artist, :album, :album_path, :image_path

    def initialize(album_path)
      @album_path = album_path
      @artist, @album = album_path.split('/').pop(2)
      @image_path = Dir.glob("#{album_path}/#{cover_title}.*").first || "/dev/null"
    end

    def album_image
      if File.file?(image_path)
        return File.open(image_path).read
      else
        info = LastFM.album_info(artist, album)
        image = info.css('album image[size=extralarge]').text

        extension = image.split('.').last
        save_image(image, extension)
      end
    end

    def songs
      Dir.glob("#{album_path}/*.mp3")
    end

    private
    def save_image(image, extension)
      @image_path = File.expand_path("#{cover_title}.#{extension}", album_path)
      File.open(File.expand_path(image_path), 'w') { |f|
        f.write open(image).read
      }
      image
    end

    def cover_title
      Digest::SHA1.hexdigest(artist + album)
    end
  end
end

