require 'sinatra'
require_relative "./parser"

get '/' do
  '<h1>Hisdasd</h1>
  <a href="/newfilms">Newfilms</a>'
end

get '/newfilms' do
  content_type :json
  parser = Crawler::Parser.new
  parser.getNewFilms
end

get '/showinfo/:url' do
  "#{params[:url]}"
end
