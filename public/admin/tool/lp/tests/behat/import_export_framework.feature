@tool @tool_lp @tool_lp_framework
Feature: Import and export competency framework
  In order to successfully import a competency framework
  As an admin
  I need to be able to export existing competency framework

  Background:
    Given I log in as "admin"
#    And I navigate to "Competencies > Competency frameworks" in site administration
#    And I click on "CF1 (CF1)" "link"
#    And I select "C1" of the competency tree
#    # Targets the unique 'Edit' link needed to open the menu, avoiding ambiguity with the other 'Edit' link.
#    And I click on "//a[@href='#' and text()='Edit']" "xpath_element"
#    # Similar to the previous step, to avoid ambiguity with the competency framework "Edit", target css element with data-action=edit.
#    When I click on "[data-action=edit]" "css_element"
#    And I set the following fields to these values:
#      | Scale | Default competence scale |
#    And I press "Configure scales"
#    And I click on "//input[@data-field='tool_lp_scale_default_1']" "xpath_element"
#    And I click on "//input[@data-field='tool_lp_scale_proficient_1']" "xpath_element"
#    And I click on "Save" "button" in the "Default competence scale" "dialogue"
#    When I press "Save changes"

  Scenario: Competency framework can be exported
    Given the following "core_competency > frameworks" exist:
      | shortname   | idnumber |
      | CF1         | CF1      |
    And the following "core_competency > competencies" exist:
      | shortname | competencyframework | idnumber |
      | C1        | CF1                 | C1       |
      | C2        | CF1                 | C2       |
      | C3        | CF1                 | C3       |
    And the following "core_competency > related_competencies" exist:
      | competency | relatedcompetency |
      | C1         | C3                |
    When I navigate to "Competencies > Export competency framework" in site administration
#    And I press "Export"
    Then following "Export" should download a file that:
      | Has mimetype | text/html |

  @javascript @_file_upload
  Scenario: Competency framework can be imported
    Given I navigate to "Competencies > Import competency framework" in site administration
    And I upload "admin/tool/lpimportcsv/tests/fixtures/example.csv" file to "CSV framework description file" filemanager
    When I press "Import"
    And I press "Confirm"
    And I navigate to "Competencies > Competency frameworks" in site administration
    And I select "Level 1" of the competency tree
    Then I should see "AAA"
