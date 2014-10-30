Feature: Edit exercise setup
  As admin or coach who owns the exercise
  I want to edit my exercise setup, I should be warned before doing so

  Background:
    Given I am logged in
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |
    And Following unit types exist in the system
      | name    |
      | decimal |
    And Following units exist in the system
      | name      | unit_type | description | abbreviation |
      | kilogramy | decimal   | váha v kg   | kg           |
      | stupne C  | decimal   | stupně C    | °C           |
    And Following exercise setups exist in the system
      | name  | description | required | unit | exercise |
      | setup | setup desc  | false    | kg   | exc1     |

  Scenario: As a coach I can edit my exercise setup, I should be warned
    Given I have "coach" role
    When I visit page "/exercises/exc1"
    Then I should see "link" containing "Edit"
    When I click "Edit"
    Then I should see warning alert message
    When I confirm popup
    Then I should see "heading" containing "exc1 - Edit exercise setup"
    When I fill in all necessary exercise setup fields
      | name     | description   |
      | setupMod | setupMod desc |
    And I select option "stupne C" from the "unit" menu
    And I click "Save changes"
    Then I should see "Exercise setup successfully updated." message
    And I should see "setupMod" in table "exercise_setups"
    And I should see "°C" in table "exercise_setup"
