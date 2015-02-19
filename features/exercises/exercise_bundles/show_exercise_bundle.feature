Feature: View exercise bundles
  In order to view available exercise bundles
  As admin I can view any exercise bundle
  As coach I can view my private exercise bundles and global exercise bundles (created by admin)

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
    And Following exercise bundles exist in the system
      | code    | name    | description  | accessibility | owner | exercise |
      | bundle1 | bundle1 | bundle1 desc | private       | test2 | exc1     |
      | bundle2 | bundle2 | bundle2 desc | global        | test1 | exc1     |
      | bundle3 | bundle3 | bundle3 desc | private       | test1 | exc2     |

  # Lists
  Scenario: As a coach I want to view all bundles I can access on a single page
    Given I am logged in as User test2
    When I visit page "/exercise_bundles/"
    Then I should see "bundle1" in table "exercise_bundles"
      And I should see "bundle2" in table "exercise_bundles"
      And I shouldn't see "bundle3" in the table "exercise_bundles"

  Scenario: As a coach I want to view all my exercise bundles on a single page
    Given I am logged in as User test2
    When I visit page "/users/test2/exercise_bundles/"
    Then I should see "bundle1" in table "exercise_bundles"
      And I shouldn't see "bundle2" in the table "exercise_bundles"
      And I shouldn't see "bundle3" in the table "exercise_bundles"

  Scenario: As admin I want to view all my private + my global exercise bundles on a single page
    Given I am logged in as User test1
    When I visit page "/users/test1/exercise_bundles/"
    Then I shouldn't see "bundle1" in the table "exercise_bundles"
      And I should see "bundle2" in table "exercise_bundles"
      And I should see "bundle3" in table "exercise_bundles"

  # bundles in Exercise detail /exercise/id/bundles
  Scenario: As a coach I want to view any bundles connected to my private exercise
    Given I am logged in as User test2
      And I am at the "/exercises/exc1" page
    Then I should see "link" containing "bundle1"
      And I should see "link" containing "bundle2"
      And I shouldn't see "link" containing "bundle3"
  # Details
  Scenario: As a coach I want to view my private exercise bundle details
    Given I am logged in as User test2
    When I visit page "/users/test2/exercise_bundles/"
    Then I should see "bundle1" in table "exercise_bundles"
    When I click "bundle1" for "bundle1" in table row
    Then I should see "heading" containing "bundle1 - Exercise bundle detail"

  Scenario: As a coach I want to view a global exercise bundle detail
    Given I am logged in as User test2
    When I visit page "/exercise_bundles/"
    Then I should see "bundle2" in table "exercise_bundles"
    When I click "bundle2" for "bundle2" in table row
    Then I should see "heading" containing "bundle2 - Exercise bundle detail"