Feature: FacilityRevision
  In order to minimize the impact of vandalism and to see which contributors are providing quality information
  As a normal user
  I want a FacilityRevision to be created a when a Facility is sucessfully saved

  Scenario: Create a new Facility
    Given I have created a new Facility
    When I go to the facilities page for
    Then I should see "Revision 1"

  Scenario: Update a Facility
    Given I have Facility which is on revision 4
    When I update that Facility
    And I go to the facilities page for
    Then I should see "Revision 5"
