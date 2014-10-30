Feature: Edit an existing exercise set
  In order to manage exercise sets
  As admin or coach who owns the set
  I want to edit an exercise set

  Background:
    Given I am logged in
    And Following exercises exist in the system
      | name | description | accessibility | owner |
      | exc1 | exc1 desc   | private       | test1 |
    And Following exercise sets exist in the system
      | name | description | accessibility | owner | exercise |
      | set1 | set1 desc   | private       | test1 | exc1     |

  Scenario: As a coach I want to modify my exercise set, I should be warned before doing so
    Given I have "coach" role
    When I am at the "/exercise_sets" page
    Then I should see "set1" in table "exercise_sets_private"
    And I should see "Edit" for "set1" in the table row
    When I click "Edit" for "set1" in table row
    Then I should see warning alert message
    When I confirm popup
    Then I should see "heading" containing "Edit exercise set"
    And I shouldn't see "code" field
    When I fill in all required fields for exercise set
      | name    | description  |
      | modset1 | modset1 desc |
    And I click "Save changes"
    Then I should see "Exercise set successfully changed." message
    And I should see "modset1" in table "exercise_sets_private"
    And I shouldn't see "set1" in the table "exercise_sets_private"
