@core @core_calendar
Feature: Perform calendar filter actions
  In order to test the calendar filters with preselected options
  As a user
  I need to filter calendar events by certain criteria

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "categories" exist:
      | name          | idnumber      | category |
      | Year          | year          |          |
      | Department C1 | department-c1 | year     |
    And the following "courses" exist:
      | fullname | shortname | format | category      |
      | Course 1 | C1        | topics | department-c1 |
      | Course 2 | C2        | topics | year          |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | teacher1 | C2     | editingteacher |
    And the following "groups" exist:
      | name    | course | idnumber |
      | Group 1 | C1     | G1       |
    And the following "group members" exist:
      | user     | group |
      | teacher1 | G1    |
#    And the following "events" exist:
#      | name       | eventtype | timestart |
#      | Site event | site      | ##now##   |
    And the following "events" exist:
      | name      | eventtype | course | timestart         |
      | C1 event  | course    | C1     | ##tomorrow noon## |
      | C2 event  | course    | C2     | ##now##           |
    And the following "events" exist:
      | name        | eventtype | category      |
      | Dep1a event | category  | department-c1 |
    And the following "events" exist:
      | name         | eventtype | group | course | timestart         |
      | Group1 event | group     | G1    | C1     | ##tomorrow noon## |
    And the following "events" exist:
      | name            | eventtype | user     | timestart        |
      | User event      | user      | teacher1 | ##-1 hour##      |
      | Past user event | user      | teacher1 | ##today -1 day## |

  @javascript
  Scenario Outline: Teacher can filter events by month, day and upcoming events
    Given I log in as "admin"
    And I am on homepage
    And I click on "New event" "button"
    And I set the field "Event title" to "Site event"
    And I set the field "Type of event" to "Site"
    And I click on "Save" "button"
    And I log in as "teacher1"
    And I follow "Calendar" in the user menu
    When I am viewing calendar in "<calendarview>" view
    Then I <siteeventview> see "Site event"
    And I <c1eventview> see "C1 event"
    And I should see "C2 event"
    And I <groupeventview> see "Group1 event"
    And I <usereventview> see "User event"
    And I <pastusereventview> see "Past user event"

    Examples:
      | calendarview | c1eventview | groupeventview | siteeventview | usereventview | pastusereventview |
      | month        | should      | should         | should        | should        | should            |
      | day          | should not  | should not     | should        | should        | should not        |
      | upcoming     | should      | should         | should not    | should not    | should not        |

  @javascript
  Scenario Outline: Teacher can filter events by course
    Given I log in as "teacher1"
    And I follow "Calendar" in the user menu
    When I set the field "course" to "<courseview>"
    And I wait until the page is ready
    Then I <c1eventview> see "C1 event"
    And I <c2eventview> see "C2 event"

    Examples:
      | courseview  | c1eventview | c2eventview |
      | All courses | should      | should      |
      | Course 1    | should      | should not  |
      | Course 2    | should not  | should      |

  @javascript
  Scenario Outline: Teacher can hide and display events in calendar
    Given I log in as "admin"
    And I am on homepage
    And I click on "New event" "button"
    And I set the field "Event title" to "Site event"
    And I set the field "Type of event" to "Site"
    And I click on "Save" "button"
    And I log in as "teacher1"
    And I follow "Calendar" in the user menu
    When I follow "<eventkeyvisibility>"
    And I wait until the page is ready
    Then I <siteeventview> see "Site event"
    And I <categoryeventview> see "Dep1a event"
    And I <courseeventview> see "C1 event"
    And I <courseeventview> see "C2 event"
    And I <groupeventview> see "Group1 event"
    And I <usereventview> see "User event"
    And I <usereventview> see "Past user event"

    Examples:
      | eventkeyvisibility   | siteeventview | categoryeventview | courseeventview | groupeventview | usereventview |
      | Hide site events     | should not    | should            | should          | should         | should        |
      | Hide category events | should        | should not        | should          | should         | should        |
      | Hide course events   | should        | should            | should not      | should         | should        |
      | Hide group events    | should        | should            | should          | should not     | should        |
      | Hide user events     | should        | should            | should          | should         | should not    |

  @javascript
  Scenario: Teacher of a Course can see his events and filter them
    When I follow "Calendar" in the user menu
    Then I should see "C1 event"
    And I should see "Dep1a event"
    And I should see "Group1 event"
    And I click on "Hide category events" "link"
    And I should see "C1 event"
    And I should not see "Dep1a event"
    And I should see "Group1 event"
    And I click on "Hide course events" "link"
    And I should not see "C1 event"
    And I should not see "Dep1a event"
    And I should see "Group1 event"

  Scenario: Teacher of a Course can see only non filtered events from user preferences calendar_savedflt
    Given the following "user preferences" exist:
      | user      | preference          | value |
      | teacher1  | calendar_persistflt | 1     |
      | teacher1  | calendar_savedflt   | 13    |
    When I follow "Calendar" in the user menu
    Then I should not see "C1 event"
    And I should see "Dep1a event"
    And I should not see "Group1 event"

  Scenario: Teacher of a Course can see all events because session is used and not user preference calendar_savedflt
    Given the following "user preferences" exist:
      | user      | preference          | value |
      | teacher1  | calendar_persistflt | 0     |
      | teacher1  | calendar_savedflt   | 13    |
    When I follow "Calendar" in the user menu
    Then I should see "C1 event"
    And I should see "Dep1a event"
    And I should see "Group1 event"
