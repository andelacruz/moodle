@core @core_admin
Feature: An administrator has a plugins overview page
  In order to change plugin settings
  As an admin
  I can access a plugins overview page

  Background:
    Given I am logged in as "admin"
    And I navigate to "Plugins > Plugins overview" in site administration

  Scenario: An administrator can view plugins overview page
    When I navigate to "Plugins > Plugins overview" in site administration
    Then "Plugins overview" "text" should exist
    And "Check for available updates" "button" should exist
    And "All plugins" "link" should exist
    And "Additional plugins" "link" should exist
    And the following should exist in the "generaltable" table:
      | Plugin name         |
      | Assignment          |
      | BigBlueButton       |
      | Book                |
      | Choice              |
      | Database            |
      | Feedback            |
      | Folder              |
      | Forum               |
      | Glossary            |
      | H5P                 |
      | IMS content package |
      | Text and media area |
      | Lesson              |
      | External tool       |
      | Page                |
      | Question bank       |
      | Quiz                |
      | File                |
      | SCORM package       |
      | Subsection          |
      | URL                 |
      | Wiki                |
      | Workshop            |

  Scenario: An administrator can access list of activities when activity modules cog icon is pressed
    When I click on "Settings" "link" in the "Activity modules" "table_row"
    Then "Activities" "text" should exist
    And "Manage activities" "text" should exist in the ".breadcrumb" "css_element"
    And "Activity modules" "link" should exist in the ".breadcrumb" "css_element"

  Scenario: An administrator can access plugin settings
    When I click on "Settings" "link" in the "Assignment" "table_row"
    Then "Assignment settings" "text" should exist
    And "Assignment settings" "text" should exist in the ".breadcrumb" "css_element"
    And "Assignment" "link" should exist in the ".breadcrumb" "css_element"
    And "Activity modules" "link" should exist in the ".breadcrumb" "css_element"

  Scenario: Plugins with dependencies cannot be uninstalled
    When I navigate to "Plugins > Plugins overview" in site administration
    Then "Uninstall" "link" should not exist in the "Database" "table_row"
    And "Required by: filter_data" "text" should exist in the "Database" "table_row"

  Scenario: Cancelling plugin uninstall does not uninstall the selected plugin
    When I click on "Uninstall" "link" in the "Assignment" "table_row"
    Then "Uninstalling Assignment" "text" should exist
    And "You are about to uninstall the plugin Assignment. This will completely delete everything in the database associated with this plugin, including its configuration, log records, user files managed by the plugin etc. There is no way back and Moodle itself does not create any recovery backup. Are you SURE you want to continue?" "text" should exist
    And I click on "Cancel" "button"
    And "Uninstall" "link" should exist in the "Assignment" "table_row"

  Scenario: An administrator can uninstall a plugin
    When I click on "Uninstall" "link" in the "Shibboleth" "table_row"
    # Delete confirmation.
    And I press "Continue"
    Then "Uninstalling auth_shibboleth" "text" should exist
    And "Success" "text" should exist
    And I press "Cancel"
    And I press "Continue"
    # Current release information confirmation.
    # Since the plugin code still present in the codebase, it will be reinstalled.
    And "To be installed" "text" should exist in the "Shibboleth" "table_row"
    And I press "Upgrade Moodle database now"
    And "auth_shibboleth" "text" should exist
    And "Success" "text" should exist
    And I am logged in as "admin"
    And I navigate to "Plugins > Plugins overview" in site administration
    # Since the plugin was reinstalled automatically, Shibboleth is present on the plugins list again.
    And "Uninstall" "link" should exist in the "Shibboleth" "table_row"
