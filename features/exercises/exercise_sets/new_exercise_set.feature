Feature: Add new exercise set
  In order to manage exercise sets
  As coach or admin
  I want to add new exercise set

  Background:
    Given I am logged in

  Scenario: As a coach I want to add a new exercise set
    Given I have "coach" role
    When I am at the "/exercise_sets" page
    Then I should see "link" containing "New private exercise set"
    And I shouldn't see "link" containing "New global exercise set"
    When I click "New private exercise set"
    Then I should see "heading" containing "New exercise set"
    When I fill in all required fields for exercise_set
      | name | description |
      | set1 | set 1 desc  |
    And I click "Generate code"
    Then I should see "set1" in "code" field
    When I click "Create exercise set"
    Then I should see "Exercise set successfully created." message
    And I should see "set1" in table "exercise_sets_private"

  Scenario: As admin I want to add a new global exercise set
    Given I have "admin" role
    When I am at the "/exercise_sets" page
    Then I should see "link" containing "New global exercise set"
    And I should see "link" containing "New private exercise set"
    When I click "New global exercise set"
    Then I should see "heading" containing "New exercise set"
    When I fill in all required fields for exercise_set
      | name | description |
      | set2 | set 2 desc  |
    And I click "Generate code"
    Then I should see "set1" in "code" field
    When I click "Create exercise set"
    Then I should see "Exercise set successfully created." message
    And I should see "set2" in table "exercise_sets_global"