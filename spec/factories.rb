Factory.define :facility do |f|
  f.sequence(:name) { |n| "Guys and Dolls Hairdressers #{n}" }
  f.location "London, East Dulwich"
  f.address "125 Lordship Lane, East Dulwich, London"
  f.postcode "SE22 8HU"
  f.lat "51.45692340789993"
  f.lng "-0.0755685567855835"

end
