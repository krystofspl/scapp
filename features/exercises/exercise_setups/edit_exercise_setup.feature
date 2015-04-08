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
      | name   | description | required | unit      | exercise |
      | setup1 | setup desc  | false    | kilogramy | exc1     |

  Scenario: As a coach I can edit my exercise setup, I should be warned
    Given I have "coach" role
    When I visit page "/exercises/exc1"
    When I click "Edit" for "setup1" exercise setup
    Then I should see "heading" containing "exc1 - Edit exercise setup"
    When I fill in all required exercise setup fields
      | name     | description   |
      | setupMod | setupMod desc |
    And I select option "stupne C" from the "unit" menu
    And I click "Update setup"
    Then I should see "Exercise setup was successfully updated." message
    And I should see "setupMod" in "exercise-setups-tab"
    And I should see "°C" in "exercise-setups-tab"

  Scenario: Setup cannot be changed to "required" if exercise realization exists
    Given I have "coach" role
    And Exercise "exc1" is in use
    And I am at the "/exercises/exc1" page
    When I click "Edit"
    Then I shouldn't see "exercise_setup_required" checkbox