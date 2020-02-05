require 'Nokogiri'
require 'HTTParty'
require 'byebug'

def bulldog_scraper
    url = "https://bulldogjob.pl/companies/jobs"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    end
end

bulldog_scraper