Feature: Add exercise setup to an existing exercise
  As admin or coach who owns the exercise
  I want to add a new exercise setup to an existing exercise
  #TODO ?doplnit setupTypes

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
    And Following units exist in the system
      | name      | unit_type | description | abbreviation |
      | kilogramy | decimal   | váha v kg   | kg           |
      | jednotka2 | decimal   | test        | jed          |

  Scenario: As a coach I want to add exercise setup to my private exercise
    Given I am at the "/exercises/exc1" page
    When I click "Add exercise setup"
    Then I should see "heading" containing "exc1 - Add exercise setup"
    When I fill in all required exercise setup fields
      | name   | description    | required |
      | povrch | jaky je povrch | false    |
    And I select option "jednotka2" from the "unit" menu
    And I click "Add setup"
    Then I should see "povrch" in table "exercise_setups"
    And I should see "jed" in table "exercise_setups"

  Scenario: As a coach I can't add exercise setups to other than mine exercises
    Given I am at the "/exercises/exc2" page
    Then I shouldn't see "link" containing "Add exercise setup"

  Scenario: As admin I want to add exercise setup to (my) global exercise
    Given I am at the "/exercises/exc2" page
    When I click "Add exercise setup"
    Then I should see "heading" containing "exc2 - Add exercise setup"
    When I fill in all required exercise setup fields
      | name | description        | required |
      | vaha | kolik mam nalozeno | true     |
    And I select option "kilogramy" from the "unit" menu
    And I click "Add setup"
    Then I should see "vaha" in table "exercise_setups"
    And I should see "kg" in table "exercise_setups"