Feature: Delete exercise setup that is not in use
  As admin or coach who owns the exercise
  I want to delete my exercise setup that is not in use, otherwise it shouldn't be possible

  Background:
    Given User test1 exists
    And User "test1" has "coach" role
    And Following exercises exist in the system
      | name | description | accessibility | owner |
      | exc1 | exc1 desc   | private       | test1 |
    And Following unit types exist in the system
      | name    |
      | decimal |
    And Following units exist in the system
      | name      | unit_type | description | abbreviation |
      | kilogramy | decimal   | váha v kg   | kg           |
    And Following exercise setups exist in the system
      | name   | description | required | unit      | exercise |
      | setup1 | setup desc  | false    | kilogramy | exc1     |

  Scenario: Exercise setup that is in use can't be removed
    Given I am logged in as User test1
    And Exercise setup "setup1" is in use
    When I visit page "/exercises/exc1"
    Then Link "Delete" for "setup1" exercise setup should be disabled

  @javascript
  Scenario: As a coach I can delete my exercise setup that is not in use
    Given I am logged in as User test1
    And Exercise setup "setup1" is not in use
    When I visit page "/exercises/exc1"
    Then I should see "link" containing "Delete"
    When I click "Delete"
    And I confirm popup
    Then I shouldn't see "setup1" in the table "exercise-setups-tab"