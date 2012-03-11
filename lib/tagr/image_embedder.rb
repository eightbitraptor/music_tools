require 'taglib'

module Tagr
  class ImageEmbedder
    def initialize(album)
      @album = album
    end

    def get_mime_for(file_path)
      `file --mime-type -b #{file_path.shellescape}`.chomp
    end

    def process
      frame_factory = TagLib::ID3v2::FrameFactory.instance
      frame_factory.default_text_encoding = TagLib::String::UTF8
      @album.songs.each do |song|
        begin
          file = TagLib::MPEG::File.new(song)
          tag = file.id3v2_tag
          apic = TagLib::ID3v2::AttachedPictureFrame.new
          apic.mime_type = get_mime_for(@album.image_path)
          apic.description = "Cover"
          apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
          apic.picture = @album.album_image
          tag.add_frame(apic)
          file.save
        ensure
          file.close
        end
      end
    end
  end
end
