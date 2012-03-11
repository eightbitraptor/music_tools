# Music Tools

This repo is a collection of scripts/hacks and small utilities that I am writing
in order to manage and mutate my music collection.

The utilities here are pretty specific to my use cases and thus should be treated
as volatile. If you run them over your music collection don't expect to have any
songs left… If you do, it's a bonus.

## Tagr

Tagr is a library for munging ID3 tags on mp3's. at the moment all it can do is
add album art to songs (scraped from the Last.FM API) use it as follows:

    require 'tagr'

    a = Tagr::Album.new('/home/matth/music/envy/A Dead Sinking Story')
    Tagr::ImageEmbedder.new(a).process

Tagr makes the following assumptions:

* You will always pass in an absolute path to the album
* Your music is organized in an artist/album hierarchy
* All your music is in mp3.
