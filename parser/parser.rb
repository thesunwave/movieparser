require 'nokogiri'
require 'open-uri'
require 'json'
require 'rest-client'

module Crawler
  class Parser

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'

    def getNewFilms(url)
      page ||= Nokogiri::HTML(open(url, 'User-Agent' => USER_AGENT), 'UTF-8')
      parseList(page)
    end

    def getCurrentInfo(url)
      page ||= Nokogiri::HTML(open(url, 'User-Agent' => USER_AGENT), 'UTF-8')
      currentFilm = {
        title: page.search('//table').xpath('//td')[8].children[0].text,
        original: page.search('//table').xpath('//td')[10].children[0].text,
        year: page.search('//table').xpath('//td')[12].children[0].text,
        country: page.search('//table').xpath('//td')[14].children[0].text,
        slogan: page.search('//table').xpath('//td')[16].children[0].text,
        genre: page.search('//table').xpath('//td')[20].children.map(&:text),
        time: page.search('//table').xpath('//td')[22].children[0].text,
        description: page.search('.description')[0].children[1].children[0].text.strip,
        poster: page.search('.mobile_cover')[0].children[1].attributes['src'].value,
        url: getStream(page.search('//iframe')[1].attributes['src'].value)
      }
      currentFilm.to_json
    end

    def getTop
        page ||= Nokogiri::HTML(RestClient.get('http://baskino.com/top/'))
        table = page.search('//ul').css('.content_list_top li')
        cleanFilmList = {}
        count = 0
        table.each do |e|
          cleanFilmList[count] = {  href: e.children[1].attributes['href'].value,
                                    title: e.children[1].children[3].children[0].children.first.text,
                                    year: e.children[1].children[3].children.last.children.last.text,
                                    rating: e.children[1].children[5].children.last.text
                        }
          count += 1
        end
        cleanFilmList.to_json
    end

    def search(name)
        page ||= Nokogiri::HTML(RestClient.post('http://baskino.com/index.php?do=search', subaction: 'search', story: name))
        parseList(page)
    end

    private

    def parseList(page)
        dirtyFilmList = page.css('.shortpost')
        cleanFilmList = {}
        count = 0
        dirtyFilmList.each do |e|
          cleanFilmList[count] = { href: e.children[1].children[1].attributes['href'].value,
                                    title: e.children[1].children[1].children[1].attributes['title'].value,
                                    poster: e.children[1].children[1].children[1].attributes['src'].value
                        }
          count += 1
        end
        cleanFilmList.to_json
    end

    def getStream(url)
        videoId = url.split('/')[4]
        m3u = RestClient.post('http://staticdn.nl/sessions/create_session',
                              partner: '',
                              d_id: '21609',
                              video_token: "#{videoId}",
                              content_type: 'movie',
                              access_key: 'zNW4q9pL82sHxV',
                              cd: '1'
            )
        data = JSON.parse(m3u)
        return data
    end
  end
end
