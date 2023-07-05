@block @block_search_forums @mod_forum
Feature: The search forums block allows users to search for forum posts on course page
  In order to search for a forum post
  As a user
  I can use the search forums block

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email | idnumber |
      | teacher1 | Teacher | 1 | teacher1@example.com | T1 |
      | student1 | Student | 1 | student1@example.com | S1 |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1 | 0 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
    And I am on the "C1" "course editing" page logged in as teacher1
    And I set the field "id_newsitems" to "1"
    And I press "Save and display"
    And I turn editing mode on
    And I add the "Latest announcements" block
    And I add the "Search forums" block
    And the following "mod_forum > discussions" exist:
      | user     | forum              | name            | message           |
      | teacher1 | C1 > Announcements | My subject      | My message        |

  Scenario: Use the search forum block in a course without any forum posts
    Given I am on the "Course 1" course page logged in as student1
    When I set the field "Search" to "Moodle"
    And I press "Search"
    Then I should see "No posts"

  Scenario: Use the search forum block in a course with a hidden forum and search for posts
    Given I am on the "Course 1" course page logged in as teacher1
    And I follow "Announcements"
    And I navigate to "Settings" in current page administration
    And I expand all fieldsets
    And I set the field "id_visible" to "0"
    And I press "Save and return to course"
    When I am on the "Course 1" course page logged in as student1
    And "Search forums" "block" should exist
    When I set the field "Search" to "message"
    And I press "Search"
    Then I should see "No posts"

  Scenario: Use the search forum block in a course and search for posts
    Given I am on the "Course 1" course page logged in as student1
    And "Search forums" "block" should exist
    When I set the field "Search" to "message"
    And I press "Search"
    Then I should see "My subject"
