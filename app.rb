require 'sinatra'
require 'haml'
require 'sass'
require './model'
require 'json'
require 'sinatra/streaming'

LIBRARIES = ['Musique', 'Films', 'Series']
PLAYLISTS = ['25 plus ecoutes', 'recemment ajoute', 'DrumSteCore']

helpers do
  def dist_img src, alt=""
    img "http://192.168.1.5/juvoft/#{src}", alt
  end
  
  def img src, alt =""
    haml %{%img{:src=>"#{src}", :alt=>"#{alt}"}}
  end
end

get '/style/:stylesheet/?' do |stylesheet|
  sass :"style/#{stylesheet}", :style => :compact
end

get '/music/:id/?' do |music_id|
  @musics = Musique.all :id => music_id
  haml :index
end

get '/music/:id/json/?' do |music_id|
  @music = Musique.get music_id
  halt 404 unless @music
  a = @music.attributes
  a[:url] = "http://#{request.host_with_port}/music/#{@music.id}/audio"
  a.to_json
end

get '/music/:id/audio/?' do |music_id|
  @music = Musique.get music_id
  halt 404 unless @music
  send_file 'public/'+@music.url.path
end

before '/search/?*' do
  @musics = []
  ['artist', 'album'].each do |field|
    next unless params.key? field
    @musics |= Musique.all :"#{field}" => params[field]
  end
end

get '/search' do
  haml :table_view
end

get '/search/json' do
  @musics.map{|m| m.url = "http://#{request.host_with_port}/music/#{m.id}/audio"}
  @musics.to_json
end

get '/' do
  @musics = Musique.all
  haml :table_view
end
