#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'cgi'

filepath = ARGV[0]
artist,album = filepath.split('/').pop(2)

api_key="0784e416003a552034d885f418c77c32"
api_root = "https://ws.audioscrobbler.com/2.0/?method=album.getinfo&" <<
  "api_key=#{api_key}&" <<
  "artist=#{CGI.escape(artist)}&"<<
  "album=#{CGI.escape(album)}"

begin
  puts "starting: #{artist} - #{album}"
  response = Nokogiri::XML(URI.parse(api_root).read)
  image = response.css('album image[size=extralarge]').text
  extension = image.split('.').last

  cover_file = "#{filepath}/cover.#{extension}"

  raise "CoverFile already exists" if File.file? cover_file

  File.open(cover_file, 'w') do |f|
    f.write URI.parse(image).read
  end
rescue OpenURI::HTTPError => e
  STDERR.puts e.message
ensure
  puts "*"*50
end
