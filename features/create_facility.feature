  Scenario: Required login before edit
    When I go to the create a new facility page
    Then I should see "Login"

  Scenario: Create a new facility
    Given I have logged in with a valid email and password

    When I go to the create a new facility page
    Then I should see "Add a business"

    When I fill in "name" with "Guy's and Dolls Hairdressers"
    And I fill in "facility_location" with "East Dulwich"
    And I fill in "address" with "125 Lordship Lane, East Dulwich, London"
    And I fill in "postcode" with "SE22 8HU"
    And I fill in "latitude" with "51.1"
    And I fill in "longitude" with "1.0"

    And I select "Mon" from "facility_normal_openings_attributes_0_week_day"
    And I fill in "facility_normal_openings_attributes_0_opens_at" with "9am"
    And I fill in "facility_normal_openings_attributes_0_closes_at" with "5pm"

    And I select "Tue" from "facility_normal_openings_attributes_1_week_day"
    And I fill in "facility_normal_openings_attributes_1_opens_at" with "9:00"
    And I fill in "facility_normal_openings_attributes_1_closes_at" with "5:00pm"

    And I select "Sun" from "facility_normal_openings_attributes_6_week_day"
    And I fill in "facility_normal_openings_attributes_6_opens_at" with "10am"
    And I fill in "facility_normal_openings_attributes_6_closes_at" with "16:00"

    And I press "Create"
    Then I should see "Business was successfully created"
