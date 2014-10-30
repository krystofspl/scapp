Feature: Remove exercise step from an exercise
  In order to specify exercise
  As admin or coach, who owns the exercise
  I want to remove an existing step from an existing exercise

  Background:
    Given I am logged in
    And User "test1" has "coach" role
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |
    And Following exercise steps exist in the system
      | name  | description | step_number | exercise |
      | stepA | stepA desc  | 1           | exc1     |
      | stepB | stepB desc  | 2           | exc1     |
      | stepC | stepC desc  | 3           | exc1     |
      | stepX | stepX desc  | 1           |          |

  Scenario: As a coach (owner) I want to remove a step from my exercise
    When I am at the "/exercises/exc1/exercise_steps" page
    Then I should see "stepA" in table "exercise_steps"
    And Exercise step "stepA" should have number "1"
    And I should see "stepB" in table "exercise_steps"
    And Exercise step "stepB" should have number "2"
    And I should see "stepC" in table "exercise_steps"
    And Exercise step "stepC" should have number "3"
    And I shouldn't see "stepX" in the table "exercise_steps"
    When I click "Delete" for "stepB" in table row
    Then I should see warning alert message
    When I confirm popup
    Then I should see "Exercise step successfully removed." message
    And I shouldn't see "stepB" in the table "exercise_steps"
    And Exercise step "stepA" should have number "1"
    And Exercise step "stepC" should have number "2"