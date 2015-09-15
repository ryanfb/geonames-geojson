#!/usr/bin/env ruby

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'csv'
require 'json'

def place_to_geojson(place)
	geojson = {}
	geojson["type"] = "Feature"
  geojson["title"] = place["name"]
  geojson["id"] = place["geonameid"]
  geojson["geometry"] = {
    "type" => "Point",
    "coordinates" => [place["longitude"].to_f,place["latitude"].to_f]
  }
  geojson["properties"] = {
    "title" => place["name"],
    "link" => "http://sws.geonames.org/#{place["geonameid"]}/",
    "names" => place["alternatenames"].nil? ? nil : place["alternatenames"].split(',')
  }
	return geojson
end

places_csv = ARGV[0]

$stderr.puts "Parsing places..."
CSV.foreach(places_csv, :headers => false, :col_sep => "\t", :quote_char => "\x00") do |row|
  place = {}
  place["geonameid"],
    place["name"],
    place["asciiname"],
    place["alternatenames"],
    place["latitude"],
    place["longitude"],
    place["feature class"],
    place["feature code"],
    place["country code"],
    place["cc2"],
    place["admin1 code"],
    place["admin2 code"],
    place["admin3 code"],
    place["admin4 code"],
    place["population"],
    place["elevation"],
    place["dem"],
    place["timezone"],
    place["modification date"] = row
  File.open("geojson/#{place["geonameid"]}.geojson","w") do |f|
    f.write(JSON.pretty_generate(place_to_geojson(place)))
  end
end
