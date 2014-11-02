Feature: View exercises
  In order to view available exercises
  As admin I can view any exercise
  As coach I can view my private exercises and global exercises
  #TODO !!! nemusi se nutne jednat o globalni cvik vlastneny adminem - staci pouze priznak global
  # !!! je to z duvodu, ze admin nemusi v systemu zustat natrvalo jako administrator, muze spadnout napr. na couche
  (As player I can view exercise details only as a part of an exercise realization, I can't view exercise list)
  #TODO Jako player vidim všechny cviky, který sou zařazený v realizaci training lesson, který sem součástí

  Background:
    Given User test1 exists
    And User "test1" has "admin" role
    And User test2 exists
    And User "test2" has "coach" role
    And User test3 exists
    And User "test3" has "coach" role
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test2 |
      | exc2 | exc2 | exc2 desc   | private       | test3 |
      | exc5 | exc5 | exc5 desc   | global        | test1 |

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
    Given I have "admin" role
    #private
    When I visit page "/exercises/exc1"
    Then I should see "heading" containing "exercise detail"
    #global
    When I visit page "/exercises/exc5"
    Then I should see "heading" containing "exercise detail"

  # Exercise list
  Scenario: As player I can't view the exercises list
    Given I am logged in
      And I have "player" role
    When I visit page "/exercises"
    Then I should see "exc5" in table "exercises"
      And I shouldn't see "exc2" in the table "exercises"

  Scenario: As coach I can view private exercises created by me on a single screen
    Given I am logged in as User test2
    When I visit page "/users/test2/exercises"
    Then I should see "exc1" in table "exercises"
      And I shouldn't see "exc2" in the table "exercises"

  Scenario: As coach I can view all private/global exercises accessible to me on a single screen
    Given I am logged in as User test2
    When I visit page "/exercises"
    Then I should see "exc5" in table "exercises"
      And I should see "exc1" in the table "exercises"
      And I shouldn't see "exc2" in the table "exercises"