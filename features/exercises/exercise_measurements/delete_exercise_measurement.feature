Feature: Delete exercise measurement that is not in use
  As admin or coach who owns the exercise
  I want to delete my exercise measurement that is not in use, otherwise it shouldn't be possible

  Background:
    Given User test1 exists
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
    And Following exercise measurements exist in the system
      | name        | description      | optimal_value | unit | exercise |
      | measurement | measurement desc | higher        | kg   | exc1     |

  Scenario: Exercise measurement that is in use can't be removed
    Given I am logged in as User test1
    And Exercise measurement "measurement" is in use
    When I visit page "/exercises/exc1"
    Then I shouldn't see "link" containing "Delete"

  Scenario: As a coach I can delete my exercise measurement that is not in use
    Given I am logged in as User test1
    And Exercise measurement "measurement" is not in use
    When I visit page "/exercises/exc1"
    Then I should see "link" containing "Delete"
    When I click "Delete"
    And I confirm popup
    Then I shouldn't see "measurement" in section "exercise_measurements"