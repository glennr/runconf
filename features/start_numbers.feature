Feature: Start numbers
  In order to track times
  As a timekeeper
  I want to print start numbers

  Scenario: get pdf
    Given I am signed in as "Paul"
      And a race "Scotruby 5K"
      And a user "Alex"
      And a user "Dave"
      And "Alex" is running the race "Scotruby 5K"
      And "Dave" is running the race "Scotruby 5K"
    When I download the start numbers pdf for "Scotruby 5K"
    Then I should see "Alex" with the number "1"
      And I should see "Dave" with the number "2"
    