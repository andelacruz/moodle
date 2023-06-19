@format @format_social
Feature: Change number of discussions displayed
  In order to change the number of discussions displayed
  As a teacher
  I need to edit the course and change the number of sections displayed.

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category | format |
      | Course 1 | C1 | 0 | social |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I turn editing mode on
    And I click on "Social forum" "link"
    And the following "mod_forum > discussions" exist:
      | user     | forum             | name          | subject       | message                  | created        | timemodified |
      | teacher1 | C1 > Social forum | Forum Post 10 | Forum Post 10 | This is forum post ten   | ##now +1 second## | ##now +1 second## |
      | teacher1 | C1 > Social forum | Forum Post 9  | Forum Post 9  | This is forum post nine  | ##now +2 second##  | ##now +2 second##  |
      | teacher1 | C1 > Social forum | Forum Post 8  | Forum Post 8  | This is forum post eight | ##now +3 second##  | ##now +3 second##  |
      | teacher1 | C1 > Social forum | Forum Post 7  | Forum Post 7  | This is forum post seven | ##now +4 second##  | ##now +4 second##  |
      | teacher1 | C1 > Social forum | Forum Post 6  | Forum Post 6  | This is forum post six   | ##now +5 second##  | ##now +5 second##  |
      | teacher1 | C1 > Social forum | Forum Post 5  | Forum Post 5  | This is forum post five  | ##now +6 second##  | ##now +6 second##  |
      | teacher1 | C1 > Social forum | Forum Post 4  | Forum Post 4  | This is forum post four  | ##now +7 second##  | ##now +7 second##  |
      | teacher1 | C1 > Social forum | Forum Post 3  | Forum Post 3  | This is forum post three | ##now +8 second##  | ##now +8 second##  |
      | teacher1 | C1 > Social forum | Forum Post 2  | Forum Post 2  | This is forum post two   | ##now +9 second##  | ##now +9 second##  |
      | teacher1 | C1 > Social forum | Forum Post 1  | Forum Post 1  | This is forum post one   | ##now +10 second##  | ##now +10 second##  |
    And I am on "Course 1" course homepage

  Scenario: When number of discussions is decreased fewer discussions appear
    Given I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | numdiscussions | 5 |
    When I press "Save and display"
    Then I should see "This is forum post one"
    And I should see "This is forum post five"
    And I should not see "This is forum post six"

  Scenario: When number of discussions is decreased to less than 1 only 1 discussion should appear
    Given I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | numdiscussions | -1 |
    When I press "Save and display"
    Then I should see "This is forum post one"
    And I should not see "This is forum post two"
    And I should not see "This is forum post ten"

  Scenario: When number of discussions is increased more discussions appear
    Given I navigate to "Settings" in current page administration
    And I set the following fields to these values:
      | numdiscussions | 9 |
    When I press "Save and display"
    Then I should see "This is forum post one"
    And I should see "This is forum post five"
    And I should see "This is forum post nine"
    And I should not see "This is forum post ten"
