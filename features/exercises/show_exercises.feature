Feature: View exercises
  In order to view available exercises
  As admin I can view any exercise
  As coach I can view my private exercises and global exercises
  # !!! nemusi se nutne jednat o globalni cvik vlastneny adminem - staci pouze priznak global
  # !!! je to z duvodu, ze admin nemusi v systemu zustat natrvalo jako administrator, muze spadnout napr. na couche
  #(As player I can view exercise details only as a part of an exercise realization, I can't view exercise list)

  Background:
    Given User test1 exists
    And User "test1" has "admin" role
    And User test2 exists
    And User "test2" has "coach" role
    And User test3 exists
    And User "test3" has "coach" role
    And User test4 exists
    And User "test4" has "player" role
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test2 |
      | exc2 | exc2 | exc2 desc   | private       | test3 |
      | exc5 | exc5 | exc5 desc   | global        | test1 |
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
      | test4 | training-5-5-2050-13-00-14-00 | invited       | 0                 |      |               |
    And Following exercise realizations exist in the system
      | exercise | user_created | user_partook |
      | exc1     | test2        | test4        |

  # Exercise detail
  Scenario: As coach I can't view private exercises that were not created by me
    Given I am logged in as User test2
    When I visit page "/exercises/exc2"
    Then I should see "You don't have required permissions!" message

  Scenario: As coach I can view a private exercise I own
    Given I am logged in as User test2
    When I visit page "/exercises/exc1"
    Then I should see "heading" containing "exercise detail"

  Scenario: As coach I can view a global exercise
    Given I am logged in as User test2
    When I visit page "/exercises/exc5"
    Then I should see "heading" containing "exercise detail"

  Scenario: As admin I can view any exercise
    Given I am logged in as User test1
    #private
    When I visit page "/exercises/exc1"
    Then I should see "heading" containing "exercise detail"
    #global
    When I visit page "/exercises/exc5"
    Then I should see "heading" containing "exercise detail"

  # Exercise list
  Scenario: As player I can only see exercises I partook in
    Given I am logged in as User test4
    And I have "player" role
    When I visit page "/exercises"
    Then I should see "exc1" in table "exercises"
    And I shouldn't see "exc2" in the table "exercises"
    And I shouldn't see "exc5" in the table "exercises"
    When I click "exc1"
    Then I should see "heading" containing "exercise detail"

  Scenario: As coach I can view private exercises created by me on a single screen
    Given I am logged in as User test2
    When I visit page "/users/test2/exercises"
    Then I should see "exc1" in table "exercises"
    And I shouldn't see "exc2" in the table "exercises"

  Scenario: As coach I can view all private/global exercises accessible to me on a single screen
    Given I am logged in as User test2
    When I visit page "/exercises"
    Then I should see "exc5" in table "exercises"
    And I should see "exc1" in table "exercises"
    And I shouldn't see "exc2" in the table "exercises"

  Scenario: As admin I can view all exercises on a single screen
    Given I am logged in as User test1
    When I visit page "/exercises"
    Then I should see "exc1" in table "exercises"
    And I should see "exc2" in table "exercises"
    And I should see "exc5" in table "exercises"