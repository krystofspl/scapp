Feature: Edit an existing exercise bundle
  In order to manage exercise bundles
  As admin or coach who owns the bundle
  I want to edit an exercise bundle

  Background:
    Given I am logged in
    And Following exercises exist in the system
      | name | description | accessibility | owner |
      | exc1 | exc1 desc   | private       | test1 |
    And Following exercise bundles exist in the system
      | name    | description  | accessibility | owner | exercise |
      | bundle1 | bundle1 desc | private       | test1 | exc1     |

  @javascript
  Scenario: As a coach I want to modify my exercise bundle, I should be warned before doing so
    Given I have "coach" role
    When I am at the "/exercise_bundles" page
    Then I should see "bundle1" in table "exercise_bundles"
    And I should see "Edit" for "bundle1" in the table row
    When I click "Edit" for "bundle1" in table row
    Then I should see a warning alert message
    When I confirm warning alert message
    When I fill in all required fields for exercise bundle
      | name       | description     |
      | mod1bundle | mod1bundle desc |
    And I click "Update exercise bundle"
    Then I should see "Exercise bundle was successfully updated." message
    When I visit page "/exercise_bundles/"
    Then I should see "mod1bundle" in table "exercise_bundles"
    And I shouldn't see "bundle1" in the table "exercise_bundles"
