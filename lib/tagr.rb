require 'bundler'
Bundler.setup

require_relative 'tagr/album'
require_relative 'tagr/last_fm'
require_relative 'tagr/image_embedder'

API_KEY="key"
API_SECRET="secret"

module Tagr
end
