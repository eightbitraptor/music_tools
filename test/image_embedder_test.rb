require_relative 'test_helper'
require 'tagr/image_embedder'

module Tagr
  class Album
  end
end

describe Tagr::ImageEmbedder do
  describe "processing images" do
    before do
      @album = stub(Tagr::Album).save_image
      stub(@album).album_image
      stub(@album).image_path{ "/dev/null" }
      @embedder = Tagr::ImageEmbedder.new(@album)
    end

    it "iterates over all the songs" do
      mock(@album).songs { [ "1.mp3" ] }
      @embedder.process
      verify
    end

    describe "getting a mime type" do
      it "only returns the condensed form" do
        test_file = File.expand_path('../sample_album.xml', __FILE__)
        @embedder.get_mime_for(test_file).must_equal 'application/xml'
      end
    end
  end
end
