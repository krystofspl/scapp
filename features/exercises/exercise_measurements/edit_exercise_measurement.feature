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
      | name         | description      | optimal_value | unit      | exercise |
      | measurement1 | measurement desc | higher        | kilogramy | exc1     |

  @javascript
  Scenario: As a coach I can edit my exercise measurement, I should be warned
    Given I have "coach" role
    When I visit page "/exercises/exc1"
    And I click "Exercise measurements" tab
    When I click "Edit" for "measurement1" exercise measurement
    When I fill in all required exercise measurement fields
      | name           | description         |
      | measurementMod | measurementMod desc |
    And I select option "mililitry" from the "unit" menu
    And I click "Update measurement"
    And I click "Exercise measurements" tab
    Then I should see "Exercise measurement was successfully updated." message
    And I should see "measurementMod" in table "exercise-measurements-tab"
    And I should see "ml" in table "exercise-measurements-tab"
