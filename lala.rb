#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'

require 'inifile'
require 'nokogiri'
require 'open-uri'
require 'json'

config = IniFile.load('lala.ini')
doc = Nokogiri::XML(open(config["lala"]["watchlist"]))
doc.css('guid').map{|t| t.content.split('/').last}.each_slice(50).each do |batch|
  # https://yts.re/api/listimdb.json?imdb_id[]=tt0499549&imdb_id[]=tt2024469&imdb_id[]=tt0114709
  r = open("https://yts.re/api/listimdb.json?imdb_id[]=" + batch.join('&imdb_id[]='))
  listimdb = JSON.parse r.read
  listimdb['MovieList'].each do |movie|
    match = /(\d+)p/.match(movie['Quality'])
    if match && match[1].to_i > config["lala"]["min_quality"].to_i && match[1].to_i < config["lala"]["max_quality"].to_i
      # you could call xdg-open movie["TorrentMagnetUrl"] here
      system("%s %s" % [config["lala"]["open_cmd"], movie["TorrentMagnetUrl"]]) unless config["lala"]["open_cmd"].nil?
      puts movie['MovieTitle'] + ": " + movie["ImdbLink"] # + " - " + movie["TorrentMagnetUrl"]
    end
  end
end
