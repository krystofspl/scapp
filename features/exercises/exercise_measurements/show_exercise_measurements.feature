Feature: Show exercise measurements
  As admin or coach who owns the exercise
  I want to view exercise measurements of my exercises

  Background:
    Given I am logged in
    And User test2 exists
    And User "test2" has "coach" role
    And User test3 exists
    And User "test3" has "admin" role
    And Following exercises exist in the system
      | code | name | description | accessibility | owner |
      | exc1 | exc1 | exc1 desc   | private       | test1 |
      | exc2 | exc2 | exc2 desc   | private       | test2 |
      | exc3 | exc3 | exc3 desc   | global        | test3 |
    And Following unit types exist in the system
      | name    |
      | decimal |
    And Following optimal values exist in the system
      | name   |
      | higher |
    And Following units exist in the system
      | name      | unit_type | description   | abbreviation |
      | kilogramy | decimal   | váha v kg     | kg           |
      | stupne C  | decimal   | stupne celsia | °C           |
    And Following exercise measurements exist in the system
      | name    | description | optimal_value | unit | exercise |
      | tepovka | asd         | higher        | kg   | exc1     |
      | teplota | teplota     | higher        | °C   | exc2     |
      | neco    | neco        | higher        | kg   | exc3     |

  # List = detail (detail bude rovnou na detailu exercise, jinde ne)
  Scenario: As a coach I can view exercise measurements connected to my exercise
    Given I have "coach" role
    When I visit page "/exercises/exc1"
    Then I should see "tepovka" in table "exercise_measurements"

  Scenario: As a coach I can view exercise measurements connected to a global exercise
    Given I have "coach" role
    When I visit page "/exercises/exc3"
    Then I should see "neco" in table "exercise_measurements"

  Scenario: As admin I can view other's private measurements
    Given I have "admin" role
    When I visit page "/exercises/exc2"
    Then I should see "teplota" in table "exercise_measurements"