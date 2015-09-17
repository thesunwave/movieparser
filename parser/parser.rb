require 'nokogiri'
require 'open-uri'
require 'json'
require 'rest-client'

module Crawler
  class Parser
    attr_accessor :cleanFilmList

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'

    def getNewFilms(url)
      page ||= Nokogiri::HTML(open(url, 'proxy' => '59.172.208.186:8080', 'User-Agent' => USER_AGENT), 'UTF-8')
      parseList(page)
    end

    def getCurrentInfo(url)
      page ||= Nokogiri::HTML(open(url, 'proxy' => '59.172.208.186:8080', 'User-Agent' => USER_AGENT), 'UTF-8')
      titlePage = page.xpath('//title')[0].children[0]
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
        url: page.search('//iframe')[1]
      }
      currentFilm.to_json
    end

    def search(name)
        page ||= Nokogiri::HTML(RestClient.post('http://baskino.com/index.php?do=search', :subaction => 'search', :story => name))
        parseList(page)
    end

    private

    def parseList(page)
        titlePage = page.xpath('//title')[0].children[0]
        dirtyFilmList = page.css('.shortpost')
        @cleanFilmList = {}
        count = 0
        dirtyFilmList.each do |e|
          @cleanFilmList[count] = { href: e.children[1].children[1].attributes['href'].value,
                                    title: e.children[1].children[1].children[1].attributes['title'].value,
                                    poster: e.children[1].children[1].children[1].attributes['src'].value
                        }
          count += 1
        end
        @cleanFilmList.to_json
    end

  end
end
