require_relative 'test_helper'
require 'last_fm'

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
end
