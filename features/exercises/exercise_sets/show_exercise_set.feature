Feature: View exercise sets
  In order to view available exercise sets
  As admin I can view any exercise set
  As coach I can view my private exercise sets and global exercise sets (created by admin)

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
      | exc3 | exc3 | exc3 desc   | global        | test1 |
    And Following exercise sets exist in the system
      | code | name | description | accessibility | owner | exercise |
      | set1 | set1 | set1 desc   | private       | test2 | exc1     |
      | set2 | set2 | set2 desc   | global        | test1 | exc1     |
      | set3 | set3 | set3 desc   | private       | test1 | exc2     |

  # Lists
  Scenario: As a coach I want to view all sets I can access on a single page
    Given I am logged in as User "test2"
    When I visit page "/exercise_sets/"
    Then I should see "set1" in table "exercise_sets"
    And I should see "set2" in table "exercise_sets"
    And I shouldn't see "set3" in the table "exercise_sets"

  Scenario: As a coach I want to view all my exercise sets on a single page
    Given I am logged in as User "test2"
    When I visit page "/users/test2/exercise_sets/"
    Then I should see "set1" in table "exercise_sets"
    And I shouldn't see "set2" in table "exercise_sets"
    And I shouldn't see "set3" in the table "exercise_sets"

  Scenario: As admin I want to view all my private + global exercise sets on a single page
    Given I am logged in as User "test1"
    When I visit page "/users/test1/exercise_sets/"
    Then I shouldn't see "set1" in the table "exercise_sets"
    And I should see "set2" in table "exercise_sets"
    And I should see "set3" in table "exercise_sets"

  # Sets in Exercise detail /exercise/id/sets
  Scenario: As a coach I want to view any sets connected to my private exercise
    Given I am logged in as User "test2"
    And I am at the "/exercises/exc1" page
    When I click "View sets"
    Then I should see "set1" in the table
    And I should see "set2" in the table
    And I shouldn't see "set3" in the table

  # Details
  Scenario: As a coach I want to view my private exercise set details
    Given I am logged in as User "test2"
    When I visit page "/users/test2/exercise_sets/"
    Then I should see "set1" in table "exercise_sets"
    When I click "Show" for "set1" in table row
    Then I should see "heading" containing "set1 - exercise set detail"
