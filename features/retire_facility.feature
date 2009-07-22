Feature: Retire facility
  In order to remove facilities that are no longer in operation
  As a logged in user
  I want to be able to retire a facility

  Scenario: View retired facility
    Given I have a facility which is retired
    When I go to its facility page
    Then I should see "Sorry this facility was removed from Opening Times"

  Scenario: Retire facility
    Given I have a facility with the name "Guys and Dolls Hairdressers" and the location "London, East Dulwich"
    When I go to its remove facility page
    And I check "facility[retired]"
    And I fill in "facility[comment]" with "This shop has closed down due to lack of owls"
    And I press "Remove"
    Then I should see "Sorry this facility was removed from Opening Times"
    And I should see "This shop has closed down due to lack of owls"

  Scenario: Update retired information
    Given I have a facility which is retired
    When I go to its remove facility page
    And I fill in "facility_comment" with "Still retired"
    And I press "Remove"
    Then I should see "Sorry this facility was removed from Opening Times"
    And I should see "Still retired"

  Scenario: Rejuvenated facility
    Given I have a facility which is retired
    When I go to its facility page
    And I should see "Sorry this facility was removed from Opening Times"
    And I follow "remove"
    And I uncheck "facility[retired]"
    And I fill in "facility[comment]" with "New supply of owls located - hoorah!"
    And I press "Update"
    Then I should not see "Sorry this facility was removed from Opening Times"
    And I should see "Normal opening times"
