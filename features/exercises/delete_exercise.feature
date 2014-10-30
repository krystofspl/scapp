Feature: Remove exercise
  In order to manage exercises
  As admin or coach who owns the private exercise
  I want to have the possibility to remove the exercise if it is not in use,
  otherwise it should not be possible

  Background:
    Given User test1 exists
    And User "test1" has "coach" role
    And User test2 exists
    And User "test2" has "admin" role
    And Following exercises exist in the system
      | name           | description       | accessibility | owner |
      | excprivate     | private desc      | private       | test1 |
      | excprivate2    | private2 desc     | private       | test1 |
      | excprivateused | private used desc | private       | test1 |
      | excglobal      | global desc       | global        | test2 |

  Scenario: Exercise that is in use can't be removed
    Given I am logged in as User test1
    And Exercise "excprivateused" is in use
    When I visit page "/users/test1/exercises"
    Then Link "Delete" in table row "excpublicused" should be disabled

  Scenario: As a private exercise owner (coach) I want to remove it
    Given I am logged in as User test1
    And Exercise "excprivate" is not in use
    And I am at the "/users/test1/exercises" page
    When I click "Delete" for "excprivate" in table row
    And I confirm popup
    Then I should see "Exercise successfully removed." message
    And I shouldn't see "excprivate" in the table

  Scenario: As admin I want to remove any exercise that is not in use
    Given I am logged in as User test2
    And Exercise "excprivate2" is not in use
    And I am at the "/users/test1/exercises" page
    When I click "Delete" for "excprivate2" in table row
    And I confirm popup
    Then I should see "Exercise successfully removed." message
    And I shouldn't see "excprivate2" in the table

  Scenario: As admin I want to remove my global exercise
    Given I am logged in as User test2
    And Exercise "excglobal" is not in use
    And I am at the "/users/test2/exercises" page
    When I click "Delete" for "excglobal" in table row
    And I confirm popup
    Then I should see "Exercise successfully removed." message
    And I shouldn't see "excglobal" in the table