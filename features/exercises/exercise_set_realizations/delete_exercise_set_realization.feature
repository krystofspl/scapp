Feature: Remove a set from an existing exercise realization
  In order to manage exercise realizations
  As admin or coach
  I want to remove an exercise set realization

  Background:
    Given I am logged in
    ###### USERS
    And User test1 exists
    And User test2 exists
    And Following groups exists in the system
      | name   | description | long desc | owner | visibility | is_global |
      | group1 | Group1 desc |           | test1 | members    | true      |
    And User "test2" is in group "group1"
    ###### EXERCISE
    And Following exercises exist in the system
      | name       | description  | accessibility | owner | type             |
      | excprivate | private desc | private       | test1 | ExerciseWithSets |
      | excsimple  | simple desc  | private       | test1 |                  |
    ###### LESSON
    And Following regular trainings exist in the system
      | name     | description    | is_public | for_group | owner |
      | training | private 1 desc | true      | group1    | test1 |
    And Following currencies exist in the system
      | name | code | symbol |
      | Euro | EUR  | €      |
    And Following VATs exists
      | name  | value | is_time_limited | start_of_validity | end_of_validity |
      | Basic | 20    | false           |                   |                 |
    And Following regular training lessons exist in the system
      | day | odd  | even | from  | until | regular_training | player_price_wt | group_price_wt | training_vat | currency | rental_price_wt | rental_vat | calculation        |
      | mon | true | true | 13:00 | 14:00 | training         | 20              |                | basic        | euro     | 10              | basic      | fixed_player_price |
    And Following regular training lesson realizations exist
      | regular_training | day | from  | until | date     | status    | note    | sign_in_time | excuse_time |
      | training         | mon | 13:00 | 14:00 | 5/5/2050 | scheduled | No note |              |             |
    And Following attendance entries exists
      | user  | training_realization          | participation | price_without_tax | note | excuse_reason |
      | test2 | training-5-5-2050-13-00-14-00 | invited       | 0                 |      |               |
    And Following training obligations exist
      | user  | hourly_wage_wt | vat   | currency | role       | regular_training |
      | test2 | 15             | basic | euro     | head_coach | training         |
    ###### EXERCISE REALIZATION
    And Following exercise realizations exist in the system
      | exercise   | user_created | user_partook |
      | excprivate | test1        | test2        |
      | excsimple  | test1        | test2        |
    And Following exercise set realizations exist in the system
      | exercise   | duration |
      | excprivate | 10       |
      | excprivate | 15       |

  @javascript
  Scenario: As a coach who created the realization, I want to remove a set from it
    Given I have "coach" role
    And I am at the "/scheduled_lessons/training-5-5-2050-13-00-14-00/exercise_realizations" page
    When I click Edit for exercise realization "excprivate" in plan for user "test2"
    And I click "Edit sets" tab
    When I click "Delete" for exercise set realization with index "2"
    And I confirm popup
    Then I shouldn't see an exercise set for the realization with text "10 minutes"

  @javascript
  Scenario: Exercise with sets has to have at least one set
    Given I have "coach" role
    And I am at the "/scheduled_lessons/training-5-5-2050-13-00-14-00/exercise_realizations" page
    When I click Edit for exercise realization "excprivate" in plan for user "test2"
    And I click "Edit sets" tab
    When I click "Delete" for exercise set realization with index "1"
    And I confirm popup
    When I click "Delete" for exercise set realization with index "1"
    And I confirm popup
    When I click "Delete" for exercise set realization with index "1"
    And I confirm popup
    Then I should see an error message containing "needs to have at least one set"
