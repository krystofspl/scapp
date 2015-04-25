Feature: Show exercise realizations
  In order to manage exercise realizations
  As admin or coach or player
  I want to view exercise realizations for me

  Background:
    Given User test1 exists
      And User "test1" has "coach" role
    And User test2 exists
      And User "test2" has "player" role
    And User test3 exists
      And User "test3" has "player" role
    And Following groups exists in the system
      | name   | description | long desc | owner | visibility | is_global |
      | group1 | Group1 desc |           | test1 | members    | true      |
    And User "test2" is in group "group1"
    And User "test3" is in group "group1"
    And Following exercises exist in the system
      | name       | description  | accessibility | owner |
      | excprivate | private desc | private       | test1 |
      | excglobal  | global desc  | global        | test2 |
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
      | test3 | training-5-5-2050-13-00-14-00 | invited       | 0                 |      |               |
    And Following training obligations exist
      | user  | hourly_wage_wt | vat   | currency | role       | regular_training |
      | test1 | 15             | basic | euro     | head_coach | training         |
    And Following exercise realizations exist in the system
      | exercise   | user_created | user_partook |
      | excprivate | test1        | test2        |
      | excglobal  | test1        | test3        |

  Scenario: As a player I want to view my plan for a lesson
    Given I am logged in as User test2
    And I am at the "/scheduled_lessons/training-5-5-2050-13-00-14-00/" page
    Then I shouldn't see "link" containing "Plans specification"
    # Equivalent of "Plans summary view", only for one player
    When I click "My plan"
    Then I should see "link" containing "test2"
    And I shouldn't see "link" containing "test3"
    And I should see "link" containing "excprivate"

  Scenario: As a coach I want to view plans for players in my lesson
    Given I am logged in as User test1
    And I am at the "/scheduled_lessons/training-5-5-2050-13-00-14-00/" page
    When I click "Plans summary view"
    Then I should see "link" containing "test2"
    And I should see "link" containing "test3"
    And I should see "link" containing "excprivate"
    When I click "test3"
    Then I should see "link" containing "excglobal"
