Feature: Delete exercise setup that is not in use
  As admin or coach who owns the exercise
  I want to delete my exercise setup that is not in use, otherwise it shouldn't be possible

  Background:
    Given User test1 exists
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |
    And Following unit types exist in the system
      | name    |
      | decimal |
    And Following units exist in the system
      | name      | unit_type | description | abbreviation |
      | kilogramy | decimal   | váha v kg   | kg           |
    And Following exercise setups exist in the system
      | name  | description | required | unit | exercise |
      | setup | setup desc  | false    | kg   | exc1     |

  Scenario: Exercise setup that is in use can't be removed
    Given I am logged in as User test1
      And Exercise setup "setup" is in use
    When I visit page "/exercises/exc1"
    Then I shouldn't see "link" containing "Delete"

  Scenario: As a coach I can delete my exercise setup that is not in use
    Given I am logged in as User test1
      And Exercise setup "setup" is not in use
    When I visit page "/exercises/exc1"
    Then I should see "link" containing "Delete"
    When I click "Delete"
      And I confirm popup
    Then I shouldn't see "setup" in section "exercise_setups"