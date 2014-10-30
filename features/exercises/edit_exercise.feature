#TODO dopsat funkcionalitu verzovani
Feature: Edit exercise
  In order to manage exercises
  As admin or coach who owns the private exercise
  I want to have the possibility to edit the exercise

  Background:
    Given I am logged in
    And User test2 exists
    And following exercises exist in the system
      | name       | description  | accessibility | owner |
      | excprivate | private desc | private       | test1 |
      | exc2       | exc2 desc    | private       | test2 |

  # Zde je fork: kosmeticka uprava -> povolit upravu; vetsi uprava -> clone na novou verzi
  Scenario: As a coach I can edit my private exercise, I should be warned before doing so
    Given I have "coach" role
    And I am at the "/users/test1/exercises" page
    And I should see "excprivate" in the table
    When I click "Edit" for "excprivate" in table row
    Then I should see an exercise fork dialog
    When I choose to edit the current version
    Then I shouldn't see "code" field
    When I fill in all necessary exercise fields
      | name          | description      |
      | modexcprivate | mod private desc |
    And I click "Save changes"
    Then I should see "Exercise was successfully updated." message
    And I shouldn't see "excprivate" in the table
    And I should see "modexcprivate" in the table
    And I should see "mod private desc" in the table

  Scenario: As a coach I can make a new version of my private exercise

  Scenario: As an admin I can edit any exercise, I should be warned before doing so
    Given I have "admin" role
    And I am at the "/users/test2/exercises" page
    And I should see "exc2" in the table
    When I click "Edit" for "exc2" in table row
    Then I should see warning alert message
    When I confirm popup
    Then I shouldn't see "code" field
    When I fill in all necessary exercise fields
      | name    | description    |
      | modexc2 | moddescription |
    And I click "Save changes"
    Then I should see "Exercise was successfully updated." message
    And I shouldn't see "exc2" in the table
    And I should see "modexc2" in the table
    And I should see "moddescription" in the table
