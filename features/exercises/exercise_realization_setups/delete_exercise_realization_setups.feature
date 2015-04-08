Feature: Delete existing exercise realization setup
  In order to manage exercise realizations
  As admin or coach
  I want to remove an exercise realization setup

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
      | name       | description  | accessibility | owner |
      | excprivate | private desc | private       | test1 |
      | excglobal  | global desc  | global        | test2 |
    ###### EXERCISE SETUP & UNIT
    And Following unit types exist in the system
      | name    |
      | decimal |
    And Following units exist in the system
      | name      | unit_type | description | abbreviation |
      | kilogramy | decimal   | váha v kg   | kg           |
      | stupne C  | decimal   | stupně C    | °C           |
    And Following exercise setups exist in the system
      | name   | description | required | unit      | exercise   |
      | setup1 | setup desc  | false    | kilogramy | excprivate |
      | setup2 | setup2 desc | true     | kilogramy | excprivate |
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
    And Following exercise realization setups exist in the system
      | exercise_realization_exercise | exercise_setup | value |
      | excprivate                    | setup1         | 5     |

  @javascript
  Scenario: As a coach, who created the exercise realization, I can remove setups from it
    Given I have "coach" role
    And I am at the "/scheduled_lessons/training-5-5-2050-13-00-14-00/exercise_realizations" page
    When I click Edit for exercise realization "excprivate" in plan for user "test2"
    And I click "Edit setups" tab
    And I click "Delete" for exercise realization setup "setup1"
    And I confirm popup
    Then I shouldn't see an exercise realization setup "setup1"

  @javascript
  Scenario: Required exercise setup realizations can't be deleted
    Given I have "coach" role
    And I am at the "/scheduled_lessons/training-5-5-2050-13-00-14-00/exercise_realizations" page
    When I click Edit for exercise realization "excprivate" in plan for user "test2"
    And I click "Edit setups" tab
    Then I shouldn't see "Delete" button for exercise realization setup "setup2"