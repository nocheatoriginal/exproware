require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:f_admin)
    @project = projects(:two)
    @project_type = @project.project_type
  end

  test "visiting the index" do
    visit projects_url
    assert_text I18n.t("projects.all")
    assert_selector "a", text: I18n.t("projects.new_project")
    assert_selector "a", text: I18n.t("projects.archived.archived_projects")
  end 

#Fehlermeldung : Projekttyp
  test "should create project" do
    visit projects_url
    click_on I18n.t("projects.new_project")
    save_and_open_page

    fill_in I18n.t("projects.fields.title"), with: @project.project_title
    fill_in I18n.t("projects.fields.thematic_focus"), with: @project.thematic_focus
    fill_in I18n.t("projects.fields.start_date"), with: @project.start_date
    fill_in I18n.t("projects.fields.end_date"), with: @project.end_date
    find(:option, "Dozententraining").select_option
    fill_in I18n.t("projects.fields.client"), with: @project.client
    fill_in I18n.t("projects.fields.location"), with: @project.location
    find("input[name='project[invitation_status]'][value='#{I18n.t("projects.status.sent")}']").set(true)
    find("input[name='project[participation_certificate_status]'][value='#{I18n.t("projects.status.sent")}']").set(true)
    
    click_on I18n.t("projects.save_project")
    assert_text "Projekt wurde erfolgreich erstellt."
    click_on I18n.t("projects.back_to_projects")
  end

  test "should not create project with no data" do
    visit projects_url
    click_on I18n.t("projects.new_project")
    click_on I18n.t("projects.save_project")
 
    assert_text I18n.t("projects.errors.project_could_not_be_saved")
   end


  test "should update project" do
    visit project_url(@project.id)
    click_on I18n.t("projects.edit_project"), match: :first

    fill_in I18n.t("projects.fields.title"), with: "Neuer Projekttitel"
    click_on I18n.t("projects.save_project")

    assert_text "Project was successfully updated"
    click_on I18n.t("projects.back_to_projects")
  end

#Fehlermeldung : projecttype 
  test "should show project details" do
    visit "projects/"
    click_link I18n.t("general.details"), href: project_path(@project) 

    assert_text @project.project_title
    assert_text @project.thematic_focus
    assert_text @project.start_date.strftime('%d.%m.%Y')
    assert_text @project.end_date.strftime('%d.%m.%Y')
    assert_text I18n.t("projects.fields.project_types.lecturer_training")
    assert_text @project.client
    assert_text I18n.t("projects.fields.location")
    assert_text @project.invitation_status
    assert_text @project.participation_certificate_status
    click_on I18n.t('projects.back_to_projects')
  end

  test "should archive project" do 
    visit project_url(@project.id)
    click_on I18n.t("projects.archived.archive_project"), match: :first

    assert_text "Project was successfully updated"
    click_on I18n.t("projects.back_to_archived_projects")
  end

  test "should unarchive project" do
    @project.update!(archived: true)
    visit project_url(@project.id)
  
    click_on I18n.t("projects.archived.archived_project")
  
    assert_text "Project was successfully updated"
    refute @project.reload.archived
  end

  test "should destroy project" do
    visit project_url(@project)
    page.accept_confirm do
      click_on I18n.t("projects.delete_project"), match: :first
    end
  
    assert_text "Project was successfully destroyed"
    assert_no_selector "td", text: @project.project_title
  end

  test "should not allow experts to access projects" do
    sign_in users(:f_user) 
    visit projects_url

    assert_text "Nicht autorisiert"
  end
end

