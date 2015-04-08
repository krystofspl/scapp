Feature: Add new exercise realization
  In order to manage exercise realizations
  As admin or coach
  I want to add new exercise realization

  Background:
    Given I am logged in
    And User test2 exists
    And Following groups exists in the system
      | name   | description | long desc | owner | visibility | is_global |
      | group1 | Group1 desc |           | test2 | members    | true      |
    And User "test2" is in group "group1"
    And Following exercises exist in the system
      | name       | description  | accessibility | owner |
      | excprivate | private desc | private       | test1 |
      | exc2       | exc2 desc    | global        | test2 |
    And Following regular trainings exist in the system
      | name      | description    | is_public | for_group | owner |
      | training2 | private 1 desc | true      | group1    | test2 |
    And Following currencies exist in the system
      | name | code | symbol |
      | Euro | EUR  | €      |
    And Following VATs exists
      | name  | value | is_time_limited | start_of_validity | end_of_validity |
      | Basic | 20    | false           |                   |                 |
    And Following regular training lessons exist in the system
      | day | odd  | even | from  | until | regular_training | player_price_wt | group_price_wt | training_vat | currency | rental_price_wt | rental_vat | calculation        |
      | mon | true | true | 13:00 | 14:00 | training2        | 20              |                | basic        | euro     | 10              | basic      | fixed_player_price |
    And Following regular training lesson realizations exist
      | regular_training | day | from  | until | date     | status    | note    | sign_in_time | excuse_time |
      | training2        | mon | 13:00 | 14:00 | 5/5/2050 | scheduled | No note |              |             |
    And Following attendance entries exists
      | user  | training_realization           | participation | price_without_tax | note | excuse_reason |
      | test2 | training2-5-5-2050-13-00-14-00 | invited       | 0                 |      |               |
    And Following training obligations exist
      | user  | hourly_wage_wt | vat   | currency | role       | regular_training |
      | test1 | 15             | basic | euro     | head_coach | training2        |
    And Following exercise realizations exist in the system
      | exercise | user_created | user_partook |
      | exc2     | test1        | test2        |

  #TODO randomly works/fails with "EOFError: end of file reached", test should be OK
  @javascript
  Scenario: As coach I can add a new realization
    Given I have "coach" role
    And I am at the "/scheduled_lessons/training2-5-5-2050-13-00-14-00/exercise_realizations" page
    When I drag and drop exercise "excprivate" to plan for user "test2"
    # Need to visit the page again because of caching, elements are refreshed with AJAX
    And I visit page "/scheduled_lessons/training2-5-5-2050-13-00-14-00/exercise_realizations"
    Then I should see realization "excprivate" in the plan for user "test2"
