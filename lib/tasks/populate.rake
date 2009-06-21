namespace :db do

  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'

    [Facility, Opening].each(&:delete_all)

    100.times do
      f = Facility.new
      f.name = Faker::Company.name
      f.location = Faker::Address.city
      f.address = Faker::Address.street_address
      f.postcode = "SE15 5TL" #Faker::Address.uk_postcode
      f.lat = 51.0 + rand
      f.lng = 0.0 + rand
      f.save!

      7.times do |day|
        o = NormalOpening.new
        o.facility_id = f.id
        o.sequence = day
        o.opens_at = ["0:00", "8:00", "9:00", "9:30", "10:00"].shuffle.first
        o.closes_at = ["16:30", "17:00", "18:00", "20:00", "23:00", "0:00"].shuffle.first
        o.save!
      end
    end
  end
end
