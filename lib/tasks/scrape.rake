SCRAPER_DIR = "/home/julian/code/opening-times-scrapers/"

require "#{SCRAPER_DIR}scraper.rb"
require "lib/parser_utils.rb"

namespace :scrape do
  include ParserUtils

  task(:homebase => :environment) do
    require "#{SCRAPER_DIR}/scrapers/homebase_scraper.rb"
    s = HomebaseScraper.new
    s.scrape
  end

  task(:argos => :environment) do
    require "#{SCRAPER_DIR}/scrapers/argos_scraper.rb"
    s = ArgosScraper.new
    s.scrape
  end

  task(:makro => :environment) do
    require "#{SCRAPER_DIR}/scrapers/makro_scraper.rb"
    s = MakroScraper.new
    s.scrape
  end

  task(:postoffice => :environment) do
    require "#{SCRAPER_DIR}/scrapers/post_office.rb'
    s = PostOfficeScraper.new
    s.scrape
  end

  task(:b_and_q => :environment) do
    require "#{SCRAPER_DIR}/scrapers/b_and_q_scraper.rb"
    s = BQScraper.new
    s.scrape
  end

  task(:pharmacies => :environment) do
    require "#{SCRAPER_DIR}/scrapers/pharmacy_scraper.rb"
    s = PharmacyScraper.new
    s.scrape
  end

  task(:coop => :environment) do
    require "#{SCRAPER_DIR}/scrapers/coop_scraper.rb"
    s = CoopScraper.new
    s.scrape
  end

  task(:danda => :environment) do
    require "#{SCRAPER_DIR}/scrapers/danda_scraper.rb"
    s = DandaScraper.new
    s.scrape
  end

  task(:hsbc => :environment) do
    require "#{SCRAPER_DIR}/scrapers/hsbc_scraper.rb"
    s = HsbcScraper.new
    s.scrape
  end

  task(:marksspencer => :environment) do
    require "#{SCRAPER_DIR}/scrapers/marks_spencer_scraper.rb"
    s = MarksSpencerScraper.new
    s.scrape
  end


###############
# Working versions below this line
###############

  desc "Scrape all available data"
  task(:all => [:asda,:farmfoods,:morrisons,:netto,:sainsburys,:tesco,:waitrose])

  task(:asda => :environment) do
    require "#{SCRAPER_DIR}/scrapers/asda_scraper.rb"
    s = AsdaScraper.new
    s.scrape
  end

  task(:farmfoods => :environment) do
    require "#{SCRAPER_DIR}/scrapers/farmfoods_scraper.rb"
    s = FarmfoodsScraper.new
    s.scrape
  end

  task(:morrisons => :environment) do
    require "#{SCRAPER_DIR}/scrapers/morrisons_scraper.rb"
    s = MorrisonsScraper.new
    s.scrape
  end

  task(:netto => :environment) do
    require "#{SCRAPER_DIR}/scrapers/netto_scraper.rb"
    s = NettoScraper.new
    s.scrape
  end

  task(:sainsburys => :environment) do
    require "#{SCRAPER_DIR}/scrapers/sainsburys_scraper.rb"
    s = SainsburysScraper.new
    s.scrape
  end

  task(:tesco => :environment) do
    require "#{SCRAPER_DIR}/scrapers/tesco_scraper.rb"
    s = TescoScraper.new
    s.scrape
  end

  task(:waitrose => :environment) do
    require "#{SCRAPER_DIR}/scrapers/waitrose_scraper.rb"
    s = WaitroseScraper.new
    s.scrape
  end

end

