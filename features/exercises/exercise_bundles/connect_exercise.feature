Feature: Connect exercise to exercise bundle
  In order to manage exercises
  As coach or admin
  I want to connect an existing exercise to an existing exercise bundle
  # v GLOBAL exercise bundleu mohou byt GLOBAL exercises
  # v PRIVATE exercise bundleu mohou byt GLOBAL, PRIVATE exercises

  Background:
    Given User test1 exists
    And User "test1" has "coach" role
    And User test2 exists
    And User "test2" has "admin" role
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |
      | exc2 | exc2 | exc2 desc   | private       | test2 |
      | exc3 | exc3 | exc3 desc   | global        | test2 |
    And Following exercise bundles exist in the system
      | code    | name    | description   | accessibility | owner |
      | bundle1 | bundle1 | bundle 1 desc | private       | test1 |
      | bundle2 | bundle2 | bundle 2 desc | global        | test2 |

  # Coach
  Scenario: As a coach I can connect my private/global exercise to (my) private exercise bundle
    Given I am logged in as User test1
    When I am at the "/exercise_bundles/bundle1" page
    Then I should see "heading" containing "Details"
    And I should see "heading" containing "Exercises contained within the bundle"
    When I click "Add / Remove exercises"
    Then I should see "heading" containing "Exercises contained within the bundle"
    And I should see "exc1" in table "exercises"
    And Table row for "exc1" should have "red" background
    And I should see "exc3" in table "exercises"
    And Table row for "exc3" should have "red" background
    When I click "Include" for "exc1" in table row
    Then Table row for "exc1" should have "green" background
    And I should see "Remove" for "exc1" in the table row
    When I click "Include" for "exc3" in table row
    Then Table row for "exc3" should have "green" background
    And I should see "Remove" for "exc3" in the table row

  Scenario: As a coach I can disconnect my private / a global exercise from my private exercise bundle
    Given I am logged in as User test1
    And Exercise bundle "bundle1" contains "exc1" exercise
    And Exercise bundle "bundle1" contains "exc3" exercise
    When I am at the "/exercise_bundles/bundle1" page
    Then I should see "heading" containing "Details"
    When I click "Add / Remove exercises"
    Then I should see "heading" containing "Exercises contained within the bundle"
    And I should see "exc1" in table "exercises"
    And I should see "exc3" in table "exercises"
    When I click "Remove" for "exc1" in table row
    Then Table row for "exc1" should have "red" background
    And I should see "Include" for "exc1" in the table row
    When I click "Remove" for "exc3" in table row
    Then Table row for "exc3" should have "red" background
    And I should see "Include" for "exc3" in the table row

  Scenario: As a coach I can't connect other's private exercises to any exercise bundle
    Given I am logged in as User test1
    When I am at the "/exercise_bundles/bundle1" page
    And I click "Add / Remove exercises"
    Then I should see "heading" containing "Exercises contained within the bundle"
    And I shouldn't see "exc2" in the table "exercises"

  # Admin
#????  Scenario: As an admin I can connect any private exercise to any private exercise bundle
#    Given I am logged in as User test2
#    When I am at the "/exercise_bundles/bundle1" page
#      And I click "Add / Remove exercises"
#    Then I should see "exc1" in table "exercises"
#      And I should see "exc2" in table "exercises"
#      And I should see "exc3" in table "exercises"

  Scenario: Global exercise bundle can't be connected to a private exercise
    Given I am logged in as User test2
    When I am at the "/exercise_bundles/bundle2" page
    And I click "Add / Remove exercises"
    Then I shouldn't see "exc1" in the table "exercises"
    And I shouldn't see "exc2" in the table "exercises"
    And I should see "exc3" in table "exercises"