@mod @mod_bigbluebuttonbn
Feature: Teacher can define open and close date and time
  In order to manage open and close date and time
  As a teacher
  I need to be able to set the open and close date and time

  Background:
    Given a BigBlueButton mock server is configured
    And I enable "bigbluebuttonbn" "mod" plugin
    And the following config values are set as admin:
      | bigbluebuttonbn_userlimit_editable | 1 |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | One      | teacher1@example.com |
      | student1 | Student   | One      | student1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And the following "blocks" exist:
      | blockname         | contextlevel | reference | pagetypepattern | defaultregion |
      | calendar_upcoming | System       | 1         | my-index        | side-post     |
      | calendar_month    | Course       | C1        | course-view-*   | side-pre      |

  Scenario Outline: BBB activity open and close date and time are set
    Given the following "activities" exist:
      | course | activity        | name  | openingtime | closingtime |
      | C1     | bigbluebuttonbn | BBB 1 | <opentime>  | <closetime> |
    When I am on the "BBB 1" "bigbluebuttonbn activity" page logged in as teacher1
    Then I should see "Open:"
    And I should see "<opentime>%A, %d %B %Y, %I:%M##"
    And I should see "Close:"
    And I should see "<closetime>%A, %d %B %Y, %I:%M##"
    And I am on the "Course 1" course page
    And I follow "Course calendar"
    And I <calendarvisibility> see "BBB 1"
    And I am on site homepage
    And I follow "Dashboard"
    And I <upcomingeventvisibility> see "BBB 1" in the "Upcoming events" "block"
    And I am on the "BBB 1" "bigbluebuttonbn activity" page logged in as student1
    And "Join session" "link" <buttonvisibility> exist
    And I should see "Open:"
    And I should see "<opentime>%A, %d %B %Y, %I:%M##"
    And I should see "Close:"
    And I should see "<closetime>%A, %d %B %Y, %I:%M##"
    And I am on the "Course 1" course page
    And I follow "Course calendar"
    And I <calendarvisibility> see "BBB 1"
    And I am on site homepage
    And I follow "Dashboard"
    And I <upcomingeventvisibility> see "BBB 1" in the "Upcoming events" "block"

    Examples:
      | calendarvisibility | opentime       | closetime               | buttonvisibility | upcomingeventvisibility |
      | should             | ##tomorrow##   | ##tomorrow 10:00##      | should not       | should                  |
      | should             | ##1 hour ago## | ##+2 hours##            | should           | should not              |
      | should not         | ##yesterday##  | ##yesterday +3 hours##  | should not       | should not              |
