require 'nokogiri'
require 'open-uri'
require 'json'

doc = Nokogiri::XML(open("http://rss.imdb.com/list/ls005182158/"))
puts "got imdb list"
doc.css('guid').map{|t| t.content.split('/').last}.each do |one| 
  # https://yts.to/api/v2/list_movies.jsonp?query_term=tt0068615
  r = open("https://yts.to/api/v2/list_movies.json?query_term="+one)
  
  parsed = JSON.parse r.read
  next unless parsed["data"]["movie_count"].to_i > 0
  movie  = parsed["data"]["movies"].first
  puts movie['title_long'] + ": " + "http://www.imdb.com/title/#{one}" # + " - " + movie["TorrentMagnetUrl"] 
end
