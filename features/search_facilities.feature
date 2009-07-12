Feature: Search facilities
  In order to provide a useful service
  As a user
  I want to be able find facilties near a given location

  Scenario: Search for place which doesn't exist
    When I go to the homepage
    And I fill in "location" with "Woo yay"
    And I press "Search"
    Then I should see "Sorry, no results found"

  Scenario: Search for facility by name
    Given I have created a Facility in East Dulwich
    When I go to the homepage
    And I fill in "location" with "East Dulwich"
    And I press "Search"
    Then I should see "Facilities near"
    And I should see "East Dulwich"

  Scenario: Search for facility by name
    Given I have created a Facility
    When I go to the homepage
    And I fill in "location" with "51.4, 0.0"
    And I press "Search"
    Then I should see "Facilities near"
    And I should see "51.4, 0.0"
