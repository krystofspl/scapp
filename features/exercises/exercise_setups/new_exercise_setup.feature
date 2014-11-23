Feature: Add exercise setup to an existing exercise
  As admin or coach who owns the exercise
  I want to add a new exercise setup to an existing exercise
  #TODO ?doplnit setupTypes

  #TODO !!! neni mozne aby uzivatel mohl zadat mereni s required = true pokud jiz nejaky setup existuje
  # !!!   -> je to z duvodu, ze by potom povine parametry u nekterych realizaci cviku zadanych v minulosti mohly chybet
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
    And Following units exist in the system
      | name      | unit_type | description | abbreviation |
      | kilogramy | decimal   | váha v kg   | kg           |
      | jednotka2 | decimal   | test        | jed          |

  Scenario: As a coach I want to add exercise setup to my private exercise
    Given I am logged in as User test1
    And I am at the "/exercises/exc1" page
    When I click "Add exercise setup"
    Then I should see "heading" containing "exc1 - Add exercise setup"
    When I fill in all required exercise setup fields
      | name   | description    | required |
      | povrch | jaky je povrch | false    |
    And I select option "jednotka2" from the "unit" menu
    And I click "Add exercise setup"
    Then I should see "povrch" in table "exercise_setups"
    And I should see "jednotka2" in table "exercise_setups"

  Scenario: As a coach I can't add exercise setups to other than mine exercises
    Given I am logged in as User test1
    And I am at the "/exercises/exc2" page
    Then I shouldn't see "link" containing "Add exercise setup"

  Scenario: As admin I want to add exercise setup to (my) global exercise
    Given I am logged in as User test2
    And I am at the "/exercises/exc2" page
    When I click "Add exercise setup"
    When I fill in all required exercise setup fields
      | name | description        | required |
      | vaha | kolik mam nalozeno | true     |
    And I select option "kilogramy" from the "unit" menu
    And I click "Add exercise setup"
    Then I should see "vaha" in table "exercise_setups"
    And I should see "kilogramy" in table "exercise_setups"