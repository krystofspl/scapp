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
    Then I shouldn't see "radio_button" containing "Private"
    And I shouldn't see "radio_button" containing "Global"
      # Pro coache bude "private" implicitni
    When I fill in all required fields for exercise_bundle
      | name    | description   |
      | bundle1 | bundle 1 desc |
    When I click "Create exercise bundle"
    Then I should see "Exercise bundle was successfully created." message

  Scenario: As admin I want to add a new global exercise bundle
    Given I have "admin" role
    When I am at the "/exercise_bundles" page
    Then I should see "link" containing "New exercise bundle"
    When I click "New exercise bundle"
    Then I should see "radio_button" containing "Private"
    And I should see "radio_button" containing "Global"
    And Radio button "exercise_bundle_accessibility_global" should be selected
    When I fill in all required fields for exercise_bundle
      | name    | description   |
      | bundle2 | bundle 2 desc |
    When I click "Create exercise bundle"
    Then I should see "Exercise bundle was successfully created." message
