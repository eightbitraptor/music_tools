require 'bundler'
Bundler.setup

require_relative 'last_fm'

class Tagr
  class Album
    attr_reader :artist, :album, :album_path

    def initialize(album_path)
      @album_path = album_path
      @artist, @album = album_path.split('/').pop(2)
    end

    def album_image
      @info = LastFM.album_info(artist, album)
      image = @info.css('album image[size=extralarge]').text
      save_image(open(image).read)
    end

    def songs
      Dir.glob("#{album_path}/*.mp3")
    end

    private
    def save_image(image)
      cover_title = Digest::SHA1.hexdigest(artist + album)
      File.open(File.expand_path("./#{cover_title}.png", album_path), 'w') { |f|
        f.write image
      }
    end
  end
end


