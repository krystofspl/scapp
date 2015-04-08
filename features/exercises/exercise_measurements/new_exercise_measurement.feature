Feature: Add exercise measurement to an existing exercise
  As admin or coach who owns the exercise
  I want to add a new exercise measurement to an existing exercise

  Background:
    Given User test1 exists
    And User "test1" has "coach" role
    And User test2 exists
    And User "test2" has "admin" role
    And Following exercises exist in the system
      | name | description | accessibility | owner |
      | exc1 | exc1 desc   | private       | test1 |
      | exc2 | exc2 desc   | global        | test2 |
    And Following unit types exist in the system
      | name    |
      | decimal |
      | integer |
    And Following optimal values exist in the system
      | name   |
      | higher |
      | lower  |
    And Following units exist in the system
      | name             | unit_type | description | abbreviation |
      | mililitr         | decimal   | ml          | ml           |
      | beats per minute | integer   | test        | bpm          |

  @javascript
  Scenario: As a coach I want to add exercise measurement to my private exercise
    Given I am logged in as User test1
    And I am at the "/exercises/exc1" page
    When I click "Exercise measurements" tab
    And I click "Add exercise measurement"
    And I fill in all required exercise measurement fields
      | name           | description |
      | uroven laktatu | desc        |
    And I select option "Higher is better" from the "exercise_measurement_optimal_value" menu
    And I select option "mililitr" from the "unit" menu
    And I click "Add measurement"
    When I click "Exercise measurements" tab
    Then I should see "uroven laktatu" in table "exercise-measurements-tab"
    And I should see "mililitr" in table "exercise-measurements-tab"

  Scenario: As a coach I can't add exercise measurements to other than mine exercises
    Given I am logged in as User test1
    And I am at the "/exercises/exc2" page
    Then I shouldn't see "link" containing "Add exercise measurement"

  @javascript
  Scenario: As admin I want to add exercise measurement to (my) global exercise
    Given I am logged in as User test2
    And I am at the "/exercises/exc2" page
    When I click "Exercise measurements" tab
    And I click "Add exercise measurement"
    And I fill in all required exercise measurement fields
      | name             | description  |
      | tepova frekvence | jaky mam tep |
    And I select option "Lower is better" from the "exercise_measurement_optimal_value" menu
    And I select option "beats per minute" from the "unit" menu
    And I click "Add measurement"
    When I click "Exercise measurements" tab
    Then I should see "tepova frekvence" in table "exercise-measurements-tab"
    And I should see "beats per minute" in table "exercise-measurements-tab"