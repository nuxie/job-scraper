require 'Nokogiri'
require 'Faraday'
require 'byebug'
require 'watir'
require 'watir-scroll'

def bulldog_scraper
    url = "https://bulldogjob.pl/companies/jobs"
    conn = Faraday.new
    unparsed_page = conn.get url
    parsed_page = Nokogiri::HTML(unparsed_page)
    job_offers = parsed_page.css('ul.results-list li')
    page = 1
    last_page = parsed_page.css('nav.text-center ul.pagination').text.split(' ').pop.to_i 
    jobs = Array.new
    while page <= last_page
        pagination_url = "https://bulldogjob.pl/companies/jobs?page=#{page}"
        pagination_unparsed_page = conn.get pagination_url
        pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page.body)
        pagination_job_offers = pagination_parsed_page.css('ul.results-list li.results-list-item')
        pagination_job_offers.each do |job_offer|
            job = {
                title: job_offer.css('h2.result-header').text.strip,
                location: job_offer.css('div.result-desc p.result-desc-meta span.pop-mobile').text.strip,
                company: job_offer.css('div.result-desc p.result-desc-meta span.pop-black').text.strip,
                salary: job_offer.css('div.result-desc p.result-desc-meta span.pop-green').text.strip,
                tags: job_offer.css('div.result-desc li.tags-item').text.split(/\n+/).join(" "),
                url: job_offer.css('a')[0].attributes['href'].value
            }
            jobs << job if job[:title] != ""
        end
        page += 1
    end
    return jobs
end


def justjoin_scraper
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto("https://justjoin.it/")
    browser.scroll.to :bottom
end

bulldog_scraper