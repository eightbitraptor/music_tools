require 'tagr'
require 'id3lib'

class Tagr
  class ImageEmbedder
    def initialize(album)
      @album = album
      @cover = cover
    end

    def cover
      image_data = @album.album_image
      {
        :id          => :APIC,
        :mimetype    => get_mime_for(@album.image_path),
        :picturetype => 3,
        :description => 'Cover Image',
        :textenc     => 0,
        :data        => image_data
      }
    end

    def get_mime_for(file_path)
      mime = `file --mime -b #{file_path}`
      mime.split(';').first
    end

    def process
      @album.songs.each do |song|
        begin
          tag = ID3Lib::Tag.new(song)
          tag << @cover
          tag.update!
        end
      end
    end
  end
end
