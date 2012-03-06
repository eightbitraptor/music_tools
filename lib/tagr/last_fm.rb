require 'nokogiri'
require 'cgi'

module Tagr
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
end
