require 'sinatra'
require_relative './parser'

get '/' do
  target_url = CGI.escape('http://baskino.com/films/boeviki/12442-azart-lyubvi.html')

  template = '
  <h1>Hisdasd</h1>
  <a href="/newfilms">Newfilms</a>
  <a class="link" href="/showinfo?url=<%= target_url %>">Этот неловкий</a>

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
  content_type :json
  parser = Crawler::Parser.new
  parser.getNewFilms
end

get '/showinfo' do
  "#{params[:url]}"
  content_type :json
  parser = Crawler::Parser.new
  parser.getCurrentInfo(CGI.unescape(params[:url]))
end
