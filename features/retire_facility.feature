Feature: Retire facility
  In order to remove facilities that are no longer in operation
  As a logged in user
  I want to be able to retire a facility

  Scenario: View retired facility
    Given I have a facility which is retired
    When I go to the facility page
    Then I should see "This facility has been removed from Opening Times"

  Scenario: Retired facility not in list
    Given I have a facility which is retired
    When I go to the facilities list page
    Then I should not see "Hmmm"

  Scenario: Retire facility
    Given I have a facility
    When I go to the edit facility page
    And I check "retire this facility"
    And I fill in "Comment" with "This shop has closed down due to lack of owls"
    And I click "Update"
    Then I should see "This facility has been removed from Opening Times"
    And I should see "This shop has closed down due to lack of owls"

  Scenario: Rejuvenated facility
    Given I have a facility which is retired
    When I go to the facility page
    And I should see "This facility has been removed from Opening Times"
    And I follow "Rejuvenated this facility"
    And I uncheck "retire this facility"
    And I fill in "Comment" with "New supply of owls located - hoorah!"
    And I click "Update"
    Then I should not see "This facility has been removed from Opening Times"
