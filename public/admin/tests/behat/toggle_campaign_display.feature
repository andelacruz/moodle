@core @core_admin
Feature: Toggle the campaign banner display
  In order to view the campaign banner content
  As an admin
  I need to be able to toggle the campaign banner display

  @javascript
  Scenario Outline: Admin can toggle the campaign banner display
    Given the following config values are set as admin:
      | showcampaigncontent | <displaysetting> |
    And I log in as "admin"
    When I navigate to "Notifications" in site administration
    Then "//iframe[@id='campaign-content']" "xpath_element" <display> exist

  Examples:
    | displaysetting | display    |
    | true           | should     |
    # | false          | should not |
