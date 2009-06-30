Feature: FacilityRevision
  In order to minimize the impact of vandalism and to see which contributors are providing quality information
  As a normal user
  I want a FacilityRevision to be created a when a Facility is sucessfully saved

  Scenario: Create a new Facility
    Given I have created a new Facility
    When I go to the facility revision page
    Then I should see "Current revision 1"

  Scenario: Update a Facility
    Given I have Facility which is on revision 4
    When I update that Facility
    Then I should see "Current revision 5"
