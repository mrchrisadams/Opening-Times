Feature: Create facility
  In order to build a user generated database of opening times
  As a logged in user
  I want to create a new facilty

  Scenario: Create a new facility
    When I go to the create a new facility page
    And I fill in "name" with "Guy's and Dolls Hairdressers"
    And I fill in "location" with "East Dulwich"
    And I fill in "address" with "125 Lordship Lane, East Dulwich, London"
    And I fill in "postcode" with "SE22 8HU"
    And I fill in "latitude" with "51.1"
    And I fill in "longitude" with "1.0"
    And I press "Create"
    Then I should see "Facility was successfully created"
