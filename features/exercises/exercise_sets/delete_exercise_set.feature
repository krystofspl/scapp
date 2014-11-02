Feature: Delete an existing exercise set
  In order to manage exercise sets
  As admin or coach who owns the set
  I want to delete an exercise set

  Background:
    Given I am logged in
    And Following exercises exist in the system
      | name | description | accessibility | owner |
      | exc1 | exc1 desc   | private       | test1 |
      | exc2 | exc1 desc   | global        | test1 |
    And Following exercise sets exist in the system
      | name | description | accessibility | owner | exercise |
      | set1 | set1 desc   | private       | test1 | exc1     |
      | set2 | set2 desc   | global        | test1 | exc2     |

  Scenario: As a coach who owns the private set, I can delete it, I should be warned before doing so
    Given I have "coach" role
    When I am at the "/exercise_sets" page
    Then I should see "set1" in table "exercise_sets_private"
    And I should see "Delete" for "set1" in the table row
    When I click "Delete" for "set1" in table row
    Then I should see warning alert message
    When I confirm popup
    Then I should see "Exercise set successfully deleted." message
    And I shouldn't see "set1" in the table "exercise_sets_private"
    When I visit page "/exercises/exc1"
    Then I shouldn't see "set1" in the table "exercise_sets"

  Scenario: As an admin who owns the global set, I can delete it, I should be warned before doing so
    Given I have "admin" role
    When I am at the "/exercise_sets" page
    Then I should see "set2" in table "exercise_sets_global"
    And I should see "Delete" for "set2" in the table row
    When I click "Delete" for "set2" in table row
    Then I should see warning alert message
    When I confirm popup
    Then I should see "Exercise set successfully deleted." message
    And I shouldn't see "set2" in the table "exercise_sets_global"
    When I visit page "/exercises/exc2"
    Then I shouldn't see "set2" in the table "exercise_sets"
