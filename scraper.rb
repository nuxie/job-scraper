require 'Nokogiri'
require 'HTTParty'
require 'byebug'

def bulldog_scraper
    url = "https://bulldogjob.pl/companies/jobs"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    job_offers = parsed_page.css('ul.results-list li')
    job_offers.each do |job_offer|
        job = job_offer.css('h2.result-header').text.strip
    end
end

bulldog_scraper