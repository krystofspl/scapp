Feature: Edit exercise measurement
  As admin or coach who owns the exercise
  I want to edit my exercise measurement, I should be warned before doing so

  Background:
    Given I am logged in
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |
    And Following unit types exist in the system
      | name    |
      | decimal |
    And Following optimal values exist in the system
      | name   |
      | higher |
    And Following units exist in the system
      | name      | unit_type | description | abbreviation |
      | kilogramy | decimal   | váha v kg   | kg           |
      | mililitry | decimal   | ml          | ml           |
    And Following exercise measurements exist in the system
      | name        | description      | optimal_value | unit | exercise |
      | measurement | measurement desc | higher        | kg   | exc1     |

  Scenario: As a coach I can edit my exercise measurement, I should be warned
    Given I have "coach" role
    When I visit page "/exercises/exc1"
    Then I should see "link" containing "Edit"
    When I click "Edit"
    Then I should see warning alert message
    When I confirm popup
    Then I should see "heading" containing "exc1 - Edit exercise measurement"
    When I fill in all necessary exercise measurement fields
      | name           | description         |
      | measurementMod | measurementMod desc |
    And I select option "mililitry" from the "unit" menu
    And I click "Save changes"
    Then I should see "Exercise measurement successfully updated." message
    And I should see "measurementMod" in table "exercise_measurements"
    And I should see "ml" in table "exercise_measurement"
