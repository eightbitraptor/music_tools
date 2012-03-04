require 'bundler'
Bundler.setup

require 'cgi'
require 'open-uri'
require 'nokogiri'

API_KEY="0784e416003a552034d885f418c77c32"
API_SECRET="ee64fc64c4727db5e3b034af00a68b7b"

class LastFM
  def self.album_info(artist, album)
    instance = new
    query = instance.build_request('album.getinfo', artist: artist, album: album)
    @response ||= Nokogiri::XML(open(query))
  end

  def initialize
    @api_root = "https://ws.audioscrobbler.com/2.0/"
    @api_key, @secret = API_KEY, API_SECRET
  end

  def build_request(method, params={})
    params.merge!({method: method, api_key: @api_key})
    param_str = params.to_a.map{ |a|
      "#{a.first}=#{CGI::escape(a.last)}"
    }.join('&')
    @api_root + "?" + param_str
  end
end

class Tagr
  class Album
    attr_reader :artist, :album, :album_path

    def initialize(album_path)
      @album_path = album_path
      @artist, @album = album_path.split('/').pop(2)
    end

    def album_image
      @info = LastFM.album_info(artist, album)
      image = @info.css('album image[size=extralarge]').text
      save_image(open(image).read)
    end

    def songs
      Dir.glob("#{album_path}/*.mp3")
    end

    private
    def save_image(image)
      cover_title = Digest::SHA1.hexdigest(artist + album)
      File.open(File.expand_path("./#{cover_title}.png", album_path), 'w') { |f|
        f.write image
      }
    end
  end
end


