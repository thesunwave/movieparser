require 'mechanize'
require 'json'
require 'rest-client'

module Crawler
    class Moonwalk

        def initialize#(id)
            #@id = id
            @agent = Mechanize.new do |agent|
                agent.user_agent_alias = 'Mac Safari'
            end
            @page = @agent.get('http://moonwalk.co/moonwalk/search')
        end

        def getFilm(id)
            search_result = @page.form do |search|
                search.kinopoisk_id = id
            end.submit
            link = search_result.search('.btn-primary').first.attributes['href'].value
            link.gsub!('.co/', '.cc/')
            url = { :url => link }.to_json
        end
    end
end
