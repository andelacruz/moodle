@mod @mod_scorm
Feature: Scorm reports provide tracking data and scores to teachers
  In order to track data and scores for scorm activities
  As a teacher
  I need to be able to view scorm reports

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | One      | teacher1@example.com |
      | student1 | Student   | One      | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | student1 | C1     | student        |
      | teacher1 | C1     | editingteacher |
    And the following "activity" exists:
      | activity                 | scorm                                                         |
      | course                   | C1                                                            |
      | name                     | Music history                                                 |
      | packagefilepath          | mod/scorm/tests/packages/RuntimeMinimumCalls_SCORM12-mini.zip |
    And I am on the "Music history" "scorm activity" page logged in as student1
    And I press "Enter"
    And I switch to the main frame
    And I click on "Par?" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I switch to the main frame
    And I click on "Keeping Score" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I switch to the main frame
    And I click on "Other Scoring Systems" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I switch to the main frame
    And I click on "The Rules of Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I switch to the main frame
    And I click on "Playing Golf Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I click on "[id='question_com.scorm.golfsamples.interactions.playing_1_1']" "css_element"
    And I press "Submit Answers"
    And I wait until the page is ready
    And I switch to the main frame
    And I click on "How to Have Fun Playing Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I switch to the main frame
    And I click on "How to Make Friends Playing Golf" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I switch to the main frame
    And I click on "Having Fun Quiz" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I click on "[id='question_com.scorm.golfsamples.interactions.fun_1_False']" "css_element"
    And I press "Submit Answers"
    And I wait until the page is ready
    And I switch to the main frame
    # We need to get some time till the last item is marked as done (or it won't be ready in slow databases).
    # This could be a pause of a few seconds, but re-visiting
    # any of the pages seems to  be doing the work too under that very same slow environment.
    And I click on "Par?" "list_item"
    And I switch to "scorm_object" iframe
    And I wait until the page is ready
    And I switch to the main frame
    And I am on the "Music history" "scorm activity" page logged in as "teacher1"
    And I navigate to "Reports" in current page administration

  @javascript
  Scenario: Teacher can track data and scores in basic reports
    When I select "Basic report" from the "jump" singleselect
    Then  the following should exist in the "generaltable" table:
      | First name  | Email address        | Attempt | Started on              | Last accessed on        | Score |
      | Student One | student1@example.com | 1       | ##today##%A, %d %B %Y## | ##today##%A, %d %B %Y## | 9     |
    And I click on "1" "link" in the "Student One" "table_row"
    And the following should exist in the "generaltable" table:
      | Title                                   | Status        | Time | Score |
      | Golf Explained - Minimum Run-time Calls |               |      |       |
      | Playing the Game                        |               |      |       |
      | How to Play                             | Completed     |      |       |
      | Par?                                    | Completed     |      |       |
      | Keeping Score                           | Completed     |      |       |
      | Other Scoring Systems                   | Completed     |      |       |
      | The Rules of Golf                       | Completed     |      |       |
      | Playing Golf Quiz                       | Completed     |      |       |
      | How to Have Fun Playing Golf            | Completed     |      |       |
      | How to Make Friends Playing Golf        | Completed     |      |       |
      | Having Fun Quiz                         | Completed     |      |       |
    And I click on "Track details" "link" in the "How to Play" "table_row"
    And "Attempt 1 - Student One: How to Play - Track details" "text" should exist
    And the following should exist in the "generaltable" table:
      | Element                | Value     |
      | cmi.core.lesson_status | completed |

  @javascript
  Scenario Outline: Teacher can download scorm report in different supported formats
    Given I select "Basic report" from the "jump" singleselect
    When I click on "Download" "link"
    Then following "<fileformat>" should download a file that:
      | Has mimetype | <mimetypeformat> |

    Examples:
      | fileformat               | mimetypeformat                                                    |
      | Download in ODS format   | application/zip                                                   |
      | Download in Excel format | application/vnd.openxmlformats-officedocument.spreadsheetml.sheet |
      | Download in text format  | text/plain                                                        |

  @javascript
  Scenario: Teacher can delete selected scorm attempts
    Given I select "Basic report" from the "jump" singleselect
    When I click on "scorm-selectall-attempts" "checkbox"
    And I click on "Delete selected attempts" "button"

  @javascript
  Scenario: Teacher can track data and scores in graph reports
    When I select "Graph report" from the "jump" singleselect
    Then "Show chart data" "link" should exist
    And "Number of participants" "text" should exist
    And "Percent(%) secured" "text" should exist
    And I click on "Show chart data" "link"
    And "1" "text" should exist in the "0 - 10" "table_row"
    And "//div[@class='chart-image']" "xpath_element" should exist

  @javascript
  Scenario Outline: Teacher can track data and scores in interactions and objectives reports
    When I select "<reporttype> report" from the "jump" singleselect
    Then "1 attempts for 2 users, out of 2 results" "text" should exist
    And the following should exist in the "generaltable" table:
      | First name  | Email address        | Attempt | Started on              | Last accessed on        | Score | How to Play | Par?      | Keeping Score | Other Scoring Systems | The Rules of Golf | Playing Golf Quiz | How to Have Fun Playing Golf | How to Make Friends Playing Golf | Having Fun Quiz |
      | Student One | student1@example.com | 1       | ##today##%A, %d %B %Y## | ##today##%A, %d %B %Y## | 9     | Completed   | Completed | Completed     | Completed             | Completed         | Completed         | Completed                    | Completed                        | Completed       |

    Examples:
      | reporttype   |
      | Interactions |
      | Objectives   |
