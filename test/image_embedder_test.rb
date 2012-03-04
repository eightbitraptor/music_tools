require_relative 'test_helper'
require 'image_embedder'

describe Tagr::ImageEmbedder do
  describe "processing images" do
    before do
      @album = Tagr::Album.new("/Users/testuser/Music/envy/A Dead Sinking Story")
      stub(@album).save_image

      @embedder = Tagr::ImageEmbedder.new(@album)
    end

    it "iterates over all the songs" do
      mock(@album).songs { ["1.mp3", "2.mp3"] }
      @embedder.process
      verify
    end

    describe "getting a mime type" do
      it "only returns the condensed form" do
        @embedder.get_mime_for(__FILE__).must_equal 'text/plain'
      end
    end
  end
end
