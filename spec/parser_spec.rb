require './parser.rb'
require 'json'

RSpec.describe Crawler::Parser do
    let(:filmUrl) { 'http://baskino.com/films/detektivy/490-zelenaya-milya.html' }
    let(:newFilms) { ['http://baskino.com/films/boeviki/', 'http://baskino.com/films/komedii/'] }
    let(:parser) { Crawler::Parser.new }
    # context(:get) { JSON.parse(parser.getNewFilms(filmUrl)) }

    context '#getNewFilms' do
        it 'returns collection of new films' do
            newFilms.each do |film|
                subject = JSON.parse(parser.getNewFilms(film))
                expect(subject.size).to eq 12
            end
        end
    end
end
