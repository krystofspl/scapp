Feature: Edit exercise
  In order to manage exercises
  As admin or coach who owns the private exercise
  I want to have the possibility to edit the exercise

  Background:
    Given I am logged in
    And User test2 exists
    And Following exercises exist in the system
      | name       | description  | accessibility | owner |
      | excprivate | private desc | private       | test1 |
      | exc2       | exc2 desc    | private       | test2 |
    And Exercise "excprivate" is in use
    And Exercise "exc2" is in use

  # Zde je fork: kosmeticka uprava -> povolit upravu; vetsi uprava -> clone na novou verzi
  @javascript
  Scenario: As a coach I can edit my private exercise, I should be warned before doing so
    Given I have "coach" role
      And I am at the "/users/test1/exercises" page
      And I should see "excprivate" in the table
    When I click "Edit" for "excprivate" in table row
    Then I should see an exercise fork dialog
    # Verification code?
    When I choose to edit the current version
    When I fill in all required fields for exercise
      | name          | description      |
      | exc2private | mod private desc |
      And I click "Update Exercise"
    Then I should see "Exercise successfully updated." message
    When I visit page "/exercises"
      Then I shouldn't see "excprivate" in the table
      And I should see "exc2private" in the table
      And I should see "mod private desc" in the table

  @javascript
  Scenario: As a coach I can make a new version of my private exercise
    Given I have "coach" role
    And I am at the "/users/test1/exercises" page
    And I should see "excprivate" in the table
    When I click "Edit" for "excprivate" in table row
    Then I should see an exercise fork dialog
    # Verification code?
    When I choose to make a new version
    And I click "Update Exercise"
    Then I should see "Exercise successfully updated." message
    When I visit page "/exercises"
    Then I should see "excprivate" in the table
    And I should see "(2)" in the table

  @javascript
  Scenario: As an admin I can edit any exercise, I should be warned before doing so
    Given I have "admin" role
      And I am at the "/users/test2/exercises" page
      And I should see "exc2" in the table
    When I click "Edit" for "exc2" in table row
    Then I should see an exercise fork dialog
    # Verification code?
    When I choose to edit the current version
    When I fill in all required fields for exercise
      | name          | description      |
      | excmod2       | mod private desc |
    And I click "Update Exercise"
    Then I should see "Exercise successfully updated." message
    When I visit page "/users/test2/exercises"
    Then I shouldn't see "exc2" in the table
    And I should see "excmod2" in the table
    And I should see "mod private desc" in the table