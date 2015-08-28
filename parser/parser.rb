require 'nokogiri'
require "open-uri"
require 'json'

module Crawler
    class Parser
      attr_accessor :cleanFilmList

      NEW_FILMS =  'http://baskino.com/new/'
      USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"

      def initialize
        @new = NEW_FILMS
      end

      def getNewFilms
        @page ||= Nokogiri::HTML(open(@new, 'proxy' => '59.172.208.186:8080', 'User-Agent' => USER_AGENT))
        @titlePage = @page.xpath('//title')[0].children[0]
        dirtyFilmList = @page.css('.shortpost')
        @cleanFilmList = {}
        count  = 0
        dirtyFilmList.each do |e|
          @cleanFilmList[count] = { :href => e.children[1].children[1].attributes['href'].value,
                          :title => e.children[1].children[1].children[1].attributes['title'].value,
                          :poster => e.children[1].children[1].children[1].attributes['src'].value
                        }
          count += 1
        end
        return @cleanFilmList.to_json
      end


    end

end
