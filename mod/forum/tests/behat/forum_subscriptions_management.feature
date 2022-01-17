@mod @mod_forum
Feature: A teacher can control the subscription to a forum
  In order to change individual user's subscriptions
  As a course administrator
  I can change subscription setting for my users

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | teacher  | Teacher   | Tom      | teacher@example.com   |
      | student1 | Student   | 1        | student.1@example.com |
      | student2 | Student   | 2        | student.2@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1 | 0 |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher  | C1     | editingteacher |
      | student1 | C1     | student        |
      | student2 | C1     | student        |

  Scenario: A teacher can change toggle subscription editing on and off
    Given the following "activity" exists:
      | activity         | forum                  |
      | course           | C1                     |
      | idnumber         | f01                    |
      | intro            | Test forum description |
      | name             | Test forum name        |
    When I log in as "teacher"
    And I am on "Course 1" course homepage
    And I follow "Test forum name"
    And I follow "Show/edit current subscribers"
    Then ".userselector" "css_element" should not exist
    And "Manage subscribers" "button" should exist
    And I press "Manage subscribers"
    And ".userselector" "css_element" should exist
    And "Finish managing subscriptions" "button" should exist
    And I press "Finish managing subscriptions"
    And ".userselector" "css_element" should not exist
    And "Manage subscribers" "button" should exist
    And I press "Manage subscribers"
    And ".userselector" "css_element" should exist
    And "Finish managing subscriptions" "button" should exist
    And I press "Finish managing subscriptions"
    And ".userselector" "css_element" should not exist
    And "Manage subscribers" "button" should exist
