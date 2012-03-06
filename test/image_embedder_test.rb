require_relative 'test_helper'
require 'tagr/image_embedder'

describe Tagr::ImageEmbedder do
  describe "processing images" do
    before do
      @album = mock(@album).save_image

      @embedder = Tagr::ImageEmbedder.new(@album)
    end

    it "iterates over all the songs" do
      mock(@album).songs { [] }
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
