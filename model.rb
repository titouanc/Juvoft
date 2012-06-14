require 'data_mapper'

HERE = File.dirname File.expand_path(__FILE__)

DataMapper.setup :default, "sqlite3://#{HERE}normal.sqlite3"

class Musique
  include DataMapper::Resource
  
  property :id, Serial
  property :url, URI
  property :title, String, :length => 128
  property :artist, String, :length => 64
  property :album, String, :length => 64
end

class Tag
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :length => 32
end

class Musique
  has n, :tags, :through => Resource
end

class Tag
  has n, :musiques, :through => Resource
end

DataMapper.auto_upgrade!
