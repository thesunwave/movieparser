require 'sinatra'
require_relative './parser'

# Categories

categories = {  NEW: 'http://baskino.com/new/',
                FIGHTING: 'http://baskino.com/films/boevie-iskustva/',
                BIO: 'http://baskino.com/films/biograficheskie/',
                ACTION: 'http://baskino.com/films/boeviki/',
                WESTERN: 'http://baskino.com/films/vesterny/',
                MILITARY: 'http://baskino.com/films/voennye/',
                DETECTIVE: 'http://baskino.com/films/detektivy/',
                DRAMA: 'http://baskino.com/films/dramy/',
                HISTORICAL: 'http://baskino.com/films/istoricheskie/',
                COMEDY: 'http://baskino.com/films/komedii/',
                CRIMINAL: 'http://baskino.com/films/kriminalnye/',
                MELODRAMA: 'http://baskino.com/films/melodramy/',
                MULTFILMS: 'http://baskino.com/films/multfilmy/',
                MUSIC: 'http://baskino.com/films/myuzikly/',
                ADVENTURES: 'http://baskino.com/films/priklyuchencheskie/',
                RUSSIAN: 'http://baskino.com/films/russkie/',
                FAMILY: 'http://baskino.com/films/semeynye/',
                SPORT: 'http://baskino.com/films/sportivnye/',
                THRILLER: 'http://baskino.com/films/trillery/',
                HORROR: 'http://baskino.com/films/uzhasy/',
                FANTASTIC: 'http://baskino.com/films/fantasticheskie/'
            }


get '/' do
  target_url = CGI.escape('http://baskino.com/films/boeviki/12442-azart-lyubvi.html')

  template = '
  <h1>Films</h1>
  <% categories.each do |k, v| %>
  <a href="/newfilms?url=<%= CGI.escape(v) %>"><%= k.capitalize %></a>
  <% end %>
  <form action="/showinfo">
  <input type="text" name="url"></input>
  <input type="submit">
  </form>

  <h5>Search</h5>
  <form action="/search" method="GET">
  <input type="text" name="name"></input>
  <input type="submit">
  </form>

  <!-- <script>
    link = document.querySelectorAll("a");
    body = document.querySelector("body");

    body.onclick = function(event) {
      event.preventDefault();
      if (event.target.nodeName != "A") return;
      var href = event.target.getAttribute("href");
      var http = new XMLHttpRequest();
      var url = "/showinfo";
      http.open("GET", url, true);
      http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")

      http.onreadystatechange = function() {
        if(http.readyState == 4 && http.status == 200) {
          alert(http.responseText);
        }
      }
      http.send("url=" + href);
    }
  </script> -->
  '
  ERB.new(template).result(binding)
end

get '/newfilms' do
  content_type :json, charset: 'utf-8'
  parser = Crawler::Parser.new
  begin
      parser.getNewFilms(CGI.unescape(params[:url]))
  rescue Exception => e
      status 503
      body 'Service is not available: ' + e.message
  end
end

get '/showinfo' do
  content_type :json, charset: 'utf-8'
  parser = Crawler::Parser.new
  begin
      parser.getCurrentInfo(CGI.unescape(params[:url]))
  rescue Exception => e
      status 503
      body 'Service is not available: ' + e.message
  end
end

get '/search' do
    content_type :json, charset: 'utf-8'
    parser = Crawler::Parser.new
    begin
        if params[:name].empty?
            body 'Don\'t be an empty'
        else
            parser.search(params[:name])
        end
    rescue Exception => e
        status 503
        body 'Service is not available: ' + e.message
    end
end
