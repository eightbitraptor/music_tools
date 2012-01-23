require 'plist'

class CD
  attr_accessor :info

  def initialize(drive_identifier)
    info = `diskutil info -plist #{drive_identifier}`
    @info = Plist::parse_xml(info)
  end
end

puts CD.new('/dev/disk2').info
