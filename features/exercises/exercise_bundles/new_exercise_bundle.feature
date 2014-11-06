Feature: Add new exercise bundle
  In order to manage exercise bundles
  As coach or admin
  I want to add new exercise bundle

  Background:
    Given I am logged in

  Scenario: As a coach I want to add a new exercise bundle
    Given I have "coach" role
    When I am at the "/exercise_bundles" page
    Then I should see "link" containing "New exercise bundle"
    When I click "New exercise bundle"
    Then I should see "heading" containing "New exercise bundle"
      And I shouldn't see "radio_button" containing "Private"
      And I shouldn't see "radio_button" containing "Global"
      # Pro coache bude "private" implicitni
    When I fill in all required fields for exercise_bundle
      | name | description |
      | bundle1 | bundle 1 desc  |
      And I click "Generate code"
    Then I should see "bundle1" in "code" field
    When I click "Create exercise bundle"
    Then I should see "Exercise bundle successfully created." message
      And I should see "bundle1" in table "exercise_bundles_private"

  Scenario: As admin I want to add a new global exercise bundle
    Given I have "admin" role
    When I am at the "/exercise_bundles" page
    Then I should see "link" containing "New exercise bundle"
    When I click "New exercise bundle"
    Then I should see "heading" containing "New exercise bundle"
      And I should see "radio_button" containing "Private"
      And I should see "radio_button" containing "Global"
      And Radio button "accessibility_global" should be selected
    When I fill in all required fields for exercise_bundle
      | name | description |
      | bundle2 | bundle 2 desc  |
      And I click "Generate code"
    Then I should see "bundle2" in "code" field
    When I click "Create exercise bundle"
    Then I should see "Exercise bundle successfully created." message
      And I should see "bundle2" in table "exercise_bundles_global"