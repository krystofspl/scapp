Feature: Add exercise step to an exercise
  In order to specify exercise
  As admin or coach, who owns the exercise
  I want to add a new step to an existing exercise
  #TODO doplnit images?

  Background:
    Given I am logged in
    And User "test1" has "coach" role
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |

  Scenario: As a coach (owner) I want to add a step to my exercise
    When I am at the "/exercises/exc1/exercise_steps" page
    Then I should see "heading" containing "Add new exercise step"
    When I fill all required fields for exercise step
      | name  | description |
      | step1 | step 1 desc |
    And I click "Add step"
    Then I should see "Exercise step successfully added." message
    When I fill all required fields for exercise step
      | name  | description |
      | step2 | step 2 desc |
    And I click "Add step"
    Then I should see "Exercise step successfully added." message
    Then I should see "step1" in table "exercise_steps"
    And I should see "step2" in table "exercise_steps"