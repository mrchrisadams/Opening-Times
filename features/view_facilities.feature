Feature: View facilities
  In order to give people valuable information which will make them visit the website
  As a user
  I want to be able to view information about a facility and its opening times

  #TODO This just isn't right, need to see some examples
  Scenario: View facility
    Given I have added several facilities to the database
    When I go to the facilities page for "1"
    Then I should see "Guys and Dolls Hairdressers 1 - London, East Dulwich"
