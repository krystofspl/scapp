Feature: Delete an existing exercise bundle
  In order to manage exercise bundles
  As admin or coach who owns the bundle
  I want to delete an exercise bundle

  Background:
    Given I am logged in
    And Following exercises exist in the system
      | name | description | accessibility | owner |
      | exc1 | exc1 desc   | private       | test1 |
      | exc2 | exc1 desc   | global        | test1 |
    And Following exercise bundles exist in the system
      | name    | description  | accessibility | owner | exercise |
      | bundle1 | bundle1 desc | private       | test1 | exc1     |
      | bundle2 | bundle2 desc | global        | test1 | exc2     |

  @javascript
  Scenario: As a coach who owns the private bundle, I can delete it, I should be warned before doing so
    Given I have "coach" role
    When I am at the "/exercise_bundles" page
    Then I should see "bundle1" in table "exercise_bundles"
    And I should see "Delete" for "bundle1" in the table row
    When I click "Delete" for "bundle1" in table row
    And I confirm popup
    Then I should see "Exercise bundle was successfully deleted." message
    And I shouldn't see "bundle1" in the table "exercise_bundles"

  @javascript
  Scenario: As an admin who owns the global bundle, I can delete it, I should be warned before doing so
    Given I have "admin" role
    When I am at the "/exercise_bundles" page
    Then I should see "bundle2" in table "exercise_bundles"
    And I should see "Delete" for "bundle2" in the table row
    When I click "Delete" for "bundle2" in table row
    When I confirm popup
    Then I should see "Exercise bundle was successfully deleted." message
    And I shouldn't see "bundle2" in the table "exercise_bundles"