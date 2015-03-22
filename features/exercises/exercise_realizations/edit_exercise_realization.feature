Feature: Edit exercise realization
  In order to manage exercise realizations
  As admin or coach
  I want to edit exercise realizations

  Background:
    Given I am logged in
    And User test2 exists
    And User test3 exists
    And User test4 exists
    And Following groups exists in the system
      | name    | description     | long desc       | owner     | visibility  | is_global |
      | group1  | Group1 desc     |                 | test2     | members     | true      |
    And User "test2" is in group "group1"
    And User "test3" is in group "group1"
    And User "test4" is in group "group1"
    And Following exercises exist in the system
      | name       | description  | accessibility | owner |
      | excprivate | private desc | private       | test1 |
      | excglobal  | global desc  | global        | test2 |
    And Following regular trainings exist in the system
      | name        | description     | is_public   | for_group   | owner   |
      | training2   | private 1 desc  | true        | group1      | test2   |
    And Following currencies exist in the system
      | name      | code    | symbol    |
      | Euro      | EUR     | €         |
    And Following VATs exists
      |name   | value | is_time_limited | start_of_validity | end_of_validity |
      | Basic | 20    | false           |                   |                 |
    And Following regular training lessons exist in the system
      | day   | odd | even  | from    | until   | regular_training  | player_price_wt | group_price_wt  | training_vat  | currency  | rental_price_wt | rental_vat  | calculation           |
      | mon   | true| true  | 13:00   | 14:00   | training2         | 20              |                 | basic         | euro      | 10              | basic       | fixed_player_price    |
    And Following regular training lesson realizations exist
      | regular_training  | day   | from  | until | date      | status    | note                  | sign_in_time  | excuse_time |
      | training2         | mon   | 13:00 | 14:00 | 5/5/2050  | scheduled | No note               |               |             |
    And Following attendance entries exists
      | user      | training_realization            | participation   | price_without_tax   | note    | excuse_reason   |
      | test2     | training2-5-5-2050-13-00-14-00  | invited         | 0                   |         |                 |
      | test3     | training2-5-5-2050-13-00-14-00  | signed          | 0                   |         |                 |
      | test4     | training2-5-5-2050-13-00-14-00  | signed          | 0                   |         |                 |
    And Following training obligations exist
      | user    | hourly_wage_wt  | vat       | currency    | role              | regular_training  |
      | test1   | 15              | basic     | euro        | head_coach        | training2         |
    And Following exercise realizations exist in the system
      | exercise    | user_created | user_partook |
      | excprivate  | test1        | test2        |
      | excglobal   | test1        | test2        |

  @javascript
  Scenario: As a coach I want to edit an exercise realization
    Given I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00/exercise_realizations" page
    When I click Edit for exercise realization "excglobal" in plan for user "test2"
    When I fill in the realization edit form
    | Dhours | Dminutes | Dseconds | Rminutes | Rseconds | note  |
    | 0      | 20       | 5        | 5        | 0        | hello |
    And I click "Save realization"
    Then I should see "20 minutes" in realization "excglobal" in plan for user "test2"

  @javascript
  Scenario: As a coach I want to change order of realizations in a plan
    Given I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00/exercise_realizations" page
    Then I should see "excprivate" realization at position n. "1"
    And I should see "excglobal" realization at position n. "2"
    When I move "excprivate" realization one step down
    Then I should see "excprivate" realization at position n. "2"
    And I should see "excglobal" realization at position n. "1"

  @javascript
  Scenario: Total time of the plan is lower or equal than the total TLR time
    Given I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00/exercise_realizations" page
    When I click Edit for exercise realization "excprivate" in plan for user "test2"
    When I fill in the realization edit form
      | Dhours | Dminutes | Dseconds | Rminutes | Rseconds | note  |
      | 3      | 20       | 5        | 5        | 0        | hello |
    And I click "Save realization"
    Then I should see an error message in the form containing "duration is too long"
