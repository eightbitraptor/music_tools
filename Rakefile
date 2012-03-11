require_relative 'lib/tagr'
require 'rake/testtask'

Rake::TestTask.new do |t|
    t.pattern = "test/*_test.rb"
end

desc "Process all the music in a given folder"
task :process do
  start_dir = ENV['MUSIC_LOCATION']
  Dir.glob("#{start_dir}/*/*").each do |album_dir|
    puts album_dir
    album = Tagr::Album.new(album_dir)
    Tagr::ImageEmbedder.new(album).process
  end
end
