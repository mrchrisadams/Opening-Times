Factory.define :facility do |f|
  f.sequence(:name) { |n| "Guys and Dolls Hairdressers #{n}" }
  f.location "London, East Dulwich"
  f.address "125 Lordship Lane, East Dulwich, London"
  f.postcode "SE22 8HU"
  f.lat "51.45692340789993"
  f.lng "-0.0755685567855835"
end

Factory.define :opening do |f|
  f.association (:facility)
  f.opens_at "9am"
  f.closes_at "5pm"
end

Factory.define :normal_opening do |f|
  f.association (:facility)
  f.week_day "Mon"
  f.opens_at "9am"
  f.closes_at "5pm"
end
