require_relative 'test_helper'
require 'nokogiri'

require 'tagr/album'

module Tagr
  class LastFM
  end
end

describe "Tagr" do
  before do
    @tagr = Tagr::Album.new("/Users/testuser/Music/envy/A Dead Sinking Story")
    @xml = Nokogiri::XML(File.open(File.expand_path('../sample_album.xml', __FILE__)))
    @image_url = "http://userserve-ak.last.fm/serve/300x300/34880561.png"
    @image = File.open(File.expand_path("../sample.png", __FILE__))
  end

  it "pulls the album and artist from the path" do
    @tagr.artist.must_equal "envy"
    @tagr.album.must_equal "A Dead Sinking Story"
  end

  it "queries last.fm for the album image" do
    mock(Tagr::LastFM).album_info('envy', 'A Dead Sinking Story') { @xml }
    stub(@tagr).save_image
    stub(@tagr).open{ @image }

    @tagr.album_image
    verify
  end

  it "doesn't hit the network if the image already exists" do
    stub(File).file?{ true }
    mock(File).open(@tagr.send(:image_path)){ @image }
    dont_allow(@tagr).save_image
    @tagr.album_image
    verify
  end

  it "pulls out the correct image attribute and extension" do
    stub(Tagr::LastFM).album_info('envy', 'A Dead Sinking Story'){ @xml }
    mock(@tagr).save_image(@image_url, 'png')
    @tagr.album_image
    verify
  end

end

