require 'Nokogiri'
require 'HTTParty'
require 'byebug'

def bulldog_scraper
    url = "https://bulldogjob.pl/companies/jobs"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    job_offers = parsed_page.css('ul.results-list li')
    job_offers.each do |job_offer|
        job = {
            title: job_offer.css('h2.result-header').text.strip,
            location: job_offer.css('div.result-desc p.result-desc-meta span.pop-mobile').text.strip,
            company: job_offer.css('div.result-desc p.result-desc-meta span.pop-black').text.strip,
            salary: job_offer.css('div.result-desc p.result-desc-meta span.pop-green').text.strip,
            tags: job_offer.css('div.result-desc li.tags-item').text.split(/\n+/).join(" "),
            url: job_offer.css('a')[0].attributes['href'].value
        }
    end
end

bulldog_scraper