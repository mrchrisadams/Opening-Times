Scenario: Edit facility

  Given I have a facility with the name "Guys and Dolls Hairdressers" and the location "London, East Dulwich"
  And I have logged in with a valid email and password
  When I go to its edit facility page
  Then I should see "Edit a facility"
