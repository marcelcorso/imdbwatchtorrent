require 'nokogiri'
require 'open-uri'
require 'json'

doc = Nokogiri::XML(open("http://rss.imdb.com/list/ls005182158/"))
doc.css('guid').map{|t| t.content.split('/').last}.each_slice(50).each do |batch| 
  # https://yts.re/api/listimdb.json?imdb_id[]=tt0499549&imdb_id[]=tt2024469&imdb_id[]=tt0114709
  r = open("https://yts.re/api/listimdb.json?imdb_id[]=" + batch.join('&imdb_id[]='))
  listimdb = JSON.parse r.read
  listimdb['MovieList'].each do |movie|
    match = /(\d+)p/.match(movie['Quality'])
    if match && match[1].to_i > 710
      # you could call xdg-open movie["TorrentMagnetUrl"] here
      puts movie['MovieTitle'] + ": " + movie["ImdbLink"] # + " - " + movie["TorrentMagnetUrl"] 
    end
  end
end
