Feature: Add new exercise
  In order to manage exercises
  As admin or coach
  I want to add new exercise
  #TODO volba typu exercise (Simple/with series)

  Background:
    Given I am logged in

  Scenario: As player I can not add exercise
    Given I have "player" role
    When I visit page "/exercises"
    Then I shouldn't see "link" containing "New private exercise"
    Then I shouldn't see "link" containing "New public exercise"
    Then I shouldn't see "link" containing "New global exercise"
    When I visit page "/exercises/new"
    Then I should see "You don't have required permissions!" message

  Scenario: As coach I can add a new private exercise
    Given I have "coach" role
    When I am at the "/users/test1/exercises" page
    And I click "New private exercise"
    Then I should see "heading" containing "New exercise"
    And I shouldn't see "radio_button" containing "Private"
    And I shouldn't see "radio_button" containing "Global"
    And I should see "Create exercise and add details" action button
    When I fill in all required fields for exercise
      | name     | description |
      | exc1 abc | exc1 desc   |
    And I click "Generate code"
    Then I should see "exc1_abc" in "code" field
    When I click "Create exercise"
    Then I should see "Exercise successfully created." message
    And I should see "exc1" in table "exercises"

  Scenario: As admin I can add a new global exercise
    Given I have "admin" role
    When I am at the "/exercises" page
    And I click "New global exercise"
    Then I should see "heading" containing "New exercise"
    And I should see "radio_button" containing "Private"
    And I should see "radio_button" containing "Global"
    And Radio button "accessibility_global" should be selected
    When I fill in all required fields for exercise
      | name     | description |
      | exc2 abc | exc2 desc   |
    And I click "Generate code"
    Then I should see "exc2_abc" in "code" field
    When I click "Create exercise"
    Then I should see "Exercise successfully created." message
    And I should see "exc2" in table "exercises"