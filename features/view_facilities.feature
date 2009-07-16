Scenario: View facility
  Given I have a facility with the name "Guys and Dolls Hairdressers" and the location "London, East Dulwich"
  When I go to its facility page
  Then I should see "Guys and Dolls Hairdressers - London, East Dulwich"

Scenario: Redirect from ID
  Given I have a facility with the name "Guys and Dolls Hairdressers" and the location "London, East Dulwich"
  When I go to the facility page for ID 1
  Then I should see "Guys and Dolls Hairdressers 1 - London, East Dulwich"

Scenario: Slug redirect
  Given I have a facility in the database
  And I have added a SlugTrapFacility for slug "woo" to redirect to "guys-and-dolls-hairdressers-1-london-east-dulwich"
  When I go to the facility page for "woo"
  Then I should see "Guys and Dolls Hairdressers - London, East Dulwich"
