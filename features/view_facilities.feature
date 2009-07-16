Scenario: Not found
  Given
  When I go to the facility page for slug "foobar"
  Then I should see "The page you were looking for doesn't exist."

Scenario: View facility
  Given I have a facility with the name "Guys and Dolls Hairdressers" and the location "London, East Dulwich"
  When I go to its facility page
  Then I should see "Guys and Dolls Hairdressers - London, East Dulwich"

Scenario: Redirect from ID

Scenario: Slug redirect
  Given I have a facility with the name "Guys and Dolls Hairdressers" and the location "London, East Dulwich"
  And I have added a SlugTrapFacility for slug "woo" to redirect to "guys-and-dolls-hairdressers-london-east-dulwich"
  When I go to the facility page for slug "woo"
  Then I should see "Guys and Dolls Hairdressers - London, East Dulwich"
