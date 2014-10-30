Feature: Add exercise measurement to an existing exercise
  As admin or coach who owns the exercise
  I want to add a new exercise measurement to an existing exercise

  Background:
    Given I am logged in
    And User "test1" has "coach" role
    And User test2 exists
    And User "test2" has "admin" role
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |
      | exc2 | exc2 | exc2 desc   | global        | test2 |
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

  Scenario: As a coach I want to add exercise measurement to my private exercise
    Given I am at the "/exercises/exc1" page
    When I click "Add exercise measurement"
    Then I should see "heading" containing "exc1 - Add exercise measurement"
    When I fill in all required exercise setup fields
      | name           | description |
      | uroven laktatu | desc        |
    And I select option "higher" from the "optimal_value" menu
    And I select option "mililitr" from the "unit" menu
    And I click "Add measurement"
    Then I should see "uroven laktatu" in table "exercise_measurements"
    And I should see "ml" in table "exercise_measurements"

  Scenario: As a coach I can't add exercise measurements to other than mine exercises
    Given I am at the "/exercises/exc2" page
    Then I shouldn't see "link" containing "Add exercise measurement"

  Scenario: As admin I want to add exercise measurement to (my) global exercise
    Given I am at the "/exercises/exc2" page
    When I click "Add exercise measurement"
    Then I should see "heading" containing "exc2 - Add exercise measurement"
    When I fill in all required exercise setup fields
      | name             | description  |
      | tepova frekvence | jaky mam tep |
    And I select option "lower" from the "optimal_value" menu
    And I select option "beats per minute" from the "unit" menu
    And I click "Add measurement"
    Then I should see "tepova frekvence" in table "exercise_measurements"
    And I should see "bpm" in table "exercise_measurements"