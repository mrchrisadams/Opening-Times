
namespace :scrape do

  task(:farmfoods => [:environment]) do
    require '../scrapers/lib/scraper/farmfoods_scraper.rb'
    FarmfoodsScraper.new
  end

  task(:postoffice => [:environment]) do
    require '../scrapers/lib/scraper/post_office_scraper.rb'
    PostOfficeScraper.new
  end

  task(:tesco => [:environment]) do
    require '../scrapers/lib/scraper/tesco_scraper.rb'
    TescoScraper.new
  end

  task(:waitrose => [:environment]) do
    require '../scrapers/lib/scraper/waitrose_scraper.rb'
    WaitroseScraper.new
  end

end
