Feature: Remove exercise step from an exercise
  In order to specify exercise
  As admin or coach, who owns the exercise
  I want to remove an existing step from an existing exercise

  Background:
    Given User test1 exists
    And User "test1" has "coach" role
    And Following exercises exist in the system
      | name | description | accessibility | owner |
      | exc1 | exc1 desc   | private       | test1 |
      | exc2 | exc2 desc   | private       | test1 |
    And Following exercise steps exist in the system
      | name  | description | step_number | exercise |
      | stepA | stepA desc  | 1           | exc1     |
      | stepB | stepB desc  | 2           | exc1     |
      | stepC | stepC desc  | 3           | exc1     |
      | stepX | stepX desc  | 1           | exc2     |

  @javascript
  Scenario: As a coach (owner) I want to remove a step from my exercise
    Given I am logged in as User test1
    When I am at the "/exercises/exc1/steps" page
    Then I should see "stepA" in table "sortable"
      And Exercise step "stepA" should have number "1"
      And I should see "stepB" in table "sortable"
      And Exercise step "stepB" should have number "2"
      And I should see "stepC" in table "sortable"
      And Exercise step "stepC" should have number "3"
      And I shouldn't see "stepX" in the table "sortable"
    When I click "Delete" for "stepB" in table row
    When I confirm popup
    Then I should see "Exercise step was successfully deleted." message
      And I shouldn't see "stepB" in the table "sortable"
      And Exercise step "stepA" should have number "1"
      And Exercise step "stepC" should have number "2"