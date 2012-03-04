require 'minitest/spec'
require 'minitest/mock'
require 'minitest/autorun'
require 'ostruct'
require 'rr'
require 'tagr'

class MiniTest::Spec
  include RR::Adapters::RRMethods
end

describe "Tagr" do
  before do
    @tagr = Tagr::Album.new("/Users/matth/Music/envy/A Dead Sinking Story")
    @xml = Nokogiri::XML(File.open(File.expand_path('../sample_album.xml', __FILE__)))
    @image_url = "http://userserve-ak.last.fm/serve/300x300/34880561.png"
    @image = File.open(File.expand_path("../sample.png", __FILE__))
  end

  it "pulls the album and artist from the path" do
    @tagr.artist.must_equal "envy"
    @tagr.album.must_equal "A Dead Sinking Story"
  end

  it "queries last.fm for the album image" do
    mock(LastFM).album_info('envy', 'A Dead Sinking Story') { @xml }
    stub(@tagr).save_image
    stub(@tagr).open{ @image }

    @tagr.album_image
    verify
  end

  it "pulls out the correct image attribute" do
    stub(LastFM).album_info('envy', 'A Dead Sinking Story'){ @xml }
    mock(@tagr).open(@image_url){ @image }
    stub(@tagr).save_image

    @tagr.album_image
    verify
  end
end

describe "LastFM integration" do
  before do
    @lastfm = LastFM.new
  end

  describe "building an api url" do
    it "includes a method name" do
      url = @lastfm.build_request("method.name")
      assert_match url, /method=method.name/
    end

    it "includes the api_key" do
      url = @lastfm.build_request("method.name")
      assert_match url, /api_key=/
    end

    it "encodes optional paramters" do
      url = @lastfm.build_request('method.name', album: "Inle", artist: "Fall of Efrafa")
      assert_match /album=Inle/, url
      assert_match /Fall\+of\+Efrafa/, url
    end
  end

  describe "parsing album info" do
    before do
      @album_info = LastFM.album_info("Fall of Efrafa", "Inle")
    end
  end
end
