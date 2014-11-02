Feature: Connect exercise to exercise set
  In order to manage exercises
  As coach or admin
  I want to connect an existing exercise to an existing exercise set
  # v GLOBAL exercise setu mohou byt GLOBAL exercises
  # v PRIVATE exercise setu mohou byt GLOBAL, PRIVATE exercises

  Background:
    Given I am logged in
    And User test2 exists
    And User "test2" has "admin" role
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |
      | exc2 | exc2 | exc2 desc   | private       | test2 |
      | exc3 | exc3 | exc3 desc   | global        | test2 |
    And Following exercise sets exist in the system
      | code | name | description | accessibility | owner |
      | set1 | set1 | set 1 desc  | private       | test1 |
      | set2 | set2 | set 2 desc  | global        | test2 |

  # Coach
  Scenario: As a coach I can connect my private/global exercise to (my) private exercise set
    Given I have "coach" role
    When I am at the "/exercise_sets/set1" page
    Then I should see "heading" containing "exercise set detail"
    When I click "Edit exercises"
    Then I should see "heading" containing "edit exercises"
      And I should see "exc1" in table "exercises"
      And I should see "exc3" in table "exercises"
    When I click "Add" for "exc1" in table row
    Then Table row for "exc1" should have "green" background
      And I should see "Remove" for "exc1" in the table row
    When I click "Add" for "exc3" in table row
    Then Table row for "exc3" should have "green" background
      And I should see "Remove" for "exc3" in the table row

  Scenario: As a coach I can disconnect my private / a global exercise from my private exercise set
    Given I have "coach" role
    When I am at the "/exercise_sets/set1" page
    Then I should see "heading" containing "exercise set detail"
    When I click "Edit exercises"
    Then I should see "heading" containing "edit exercises"
      And I should see "exc1" in table "exercises"
      And I should see "exc3" in table "exercises"
    When I click "Remove" for "exc1" in table row
    Then Table row for "exc1" should have "grey" background
      And I should see "Add" for "exc1" in the table row
    When I click "Remove" for "exc3" in table row
    Then Table row for "exc3" should have "grey" background
      And I should see "Add" for "exc3" in the table row

  Scenario: As a coach I can't connect other's private exercises to any exercise set
    Given I have "coach" role
    When I am at the "/exercise_sets/set1" page
      And I click "Edit exercises"
    Then I should see "heading" containing "edit exercises"
      And I shouldn't see "exc2" in the table "exercises"

  # Admin
  Scenario: As an admin I can connect any private exercise to any private exercise set
    Given I am logged in as User "test2"
    When I am at the "/exercise_sets/set1" page
      And I click "Edit exercises"
    Then I should see "exc1" in table "exercises"
      And I should see "exc2" in table "exercises"
      And I should see "exc3" in table "exercises"

  Scenario: Global exercise set can't be connected to a private exercise
    Given I am logged in as User "test2"
    When I am at the "/exercise_sets/set2" page
      And I click "Edit exercises"
    Then I shouldn't see "exc1" in the table "exercises"
      And I shouldn't see "exc2" in the table "exercises"
      And I should see "exc3" in table "exercises"