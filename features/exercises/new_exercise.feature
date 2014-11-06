Feature: Add new exercise
  In order to manage exercises
  As admin or coach
  I want to add new exercise

  Background:
    Given I am logged in

  Scenario: As player I can not add exercise
    Given I have "player" role
    When I visit page "/exercises"
    Then I shouldn't see "link" containing "New exercise"
    When I visit page "/exercises/new"
    Then I should see "You don't have required permissions!" message

  Scenario: As coach I can add a new private exercise
    Given I have "coach" role
    When I am at the "/users/test1/exercises" page
      And I click "New exercise"
    Then I should see "heading" containing "New exercise"
      And I shouldn't see "radio_button" containing "Private"
      And I shouldn't see "radio_button" containing "Global"
      # Pro coache bude "private" implicitni
      And I should see "Create exercise and add details" action button
    When I fill in all required fields for exercise
      | name     | description | type |
      | exc1 abc | exc1 desc   | Exercise      |
      And I click "Generate code"
    #TODO !!! pokud generovani pojede dynamicky melo by to zvladat i kolize kodu (pokud jiz cvik s danym kodem existuje)
    Then I should see "exc1_abc" in "code" field
    When I click "Create exercise"
    Then I should see "Exercise successfully created." message
      And I should see "heading" containing "exc1 - Exercise detail"

  Scenario: As admin I can add a new global exercise
    Given I have "admin" role
    When I am at the "/exercises" page
      And I click "New exercise"
    Then I should see "heading" containing "New exercise"
      And I should see "radio_button" containing "Private"
      And I should see "radio_button" containing "Global"
      # Pro admina bude "global" implicitni
      And Radio button "accessibility_global" should be selected
    When I fill in all required fields for exercise
      | name     | description | type |
      | exc2 abc | exc2 desc   | ExerciseWithSets   |
    And I click "Generate code"
    Then I should see "exc2_abc" in "code" field
    When I click "Create exercise"
    Then I should see "Exercise successfully created." message
      And I should see "heading" containing "exc2 - Exercise detail"