require 'taglib'

filepath = ARGV[0]

songs = Dir.glob("#{filepath}/*.mp3")
cover_art = Dir.glob("#{filepath}/cover.{png,jpg}").first
mime_type = `file --mime-type -b "#{cover_art}"`

frame_factory = TagLib::ID3v2::FrameFactory.instance
frame_factory.default_text_encoding = TagLib::String::UTF8

songs.each do |song|
  begin
    file = TagLib::MPEG::File.new(song)
    tag = file.id3v2_tag

    apic = TagLib::ID3v2::AttachedPictureFrame.new
    apic.mime_type = mime_type
    apic.description = "Cover"

    apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
    apic.picture = open(cover_art).read

    tag.add_frame(apic)
    puts "saving #{song}"
    file.save
  rescue
    STDERR.puts "Shit! something went wrong"
  ensure
    file.close
  end
end
