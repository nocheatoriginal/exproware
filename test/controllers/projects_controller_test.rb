require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:f_admin)
    sign_in @admin
    @project = projects(:one)
    @archived_project = projects(:archived)
  end

  test "should get index" do
    get projects_url
    assert_response :success
    assert_not_nil Project.all
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "should get new" do
    get new_project_url
    assert_response :success
  end

  test "should create project with valid attributes" do
    participant_file = fixture_file_upload('test/fixtures/files/20241011_Infos_FITI.pdf')
    invitation_file = fixture_file_upload('test/fixtures/files/Metriken.xlsx')
    certificate_file = fixture_file_upload('test/fixtures/files/team_manifest.pdf')

    assert_difference("Project.count", 1) do
      post projects_url, params: {
        project: {
          project_title:                    "Neues Projekt",
          thematic_focus:                   "IT-Training",
          start_date:                       Date.today,
          end_date:                         Date.today + 1.month,
          project_type:                     "delegation_visit",
          client:                           "Test-Institut",
          location:                         "Berlin, Deutschland",
          invitation_status:                "nicht versendet",
          participation_certificate_status: "nicht versendet",
          participants_files:               [participant_file],
          invitation_files:                 [invitation_file],
          participation_certificate_files:  [certificate_file]
        }
      }
    end

    project = Project.last

    assert_redirected_to project_url(project)
    assert_equal 1, project.participants_files.count
    assert_equal 1, project.invitation_files.count
    assert_equal 1, project.participation_certificate_files.count
  end

  test "should not create project with invalid attributes" do
    assert_no_difference('Project.count') do
      post projects_url, params: { project: { project_title: '' } }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project with valid attributes" do
    patch project_url(@project), params: {
      project: {
        project_title: "Aktualisiertes Projekt",
        thematic_focus: "Aktualisiertes Thema",
        start_date: Date.today,
        end_date: Date.today + 2.months,
        project_type: "lecturer_training",
        client: "Aktualisierter Kunde",
        location: "Hamburg, Deutschland",
        invitation_status: "versendet",
        participation_certificate_status: "versendet"
      }
    }

    assert_redirected_to project_url(@project)
    @project.reload
    assert_equal "Aktualisiertes Projekt", @project.project_title
    assert_equal "lecturer_training", @project.project_type
    assert_equal "Aktualisiertes Thema", @project.thematic_focus
  end

  test "should not update project with invalid attributes" do
    patch project_url(@project), params: { project: { project_title: '' } }
    assert_response :unprocessable_entity
  end 

  test "should destroy project and remove files" do
    participant_file = fixture_file_upload('test/fixtures/files/20241011_Infos_FITI.pdf')
    invitation_file = fixture_file_upload('test/fixtures/files/Metriken.xlsx')
    certificate_file = fixture_file_upload('test/fixtures/files/team_manifest.pdf')
    
    @project.participants_files.attach(participant_file)
    @project.invitation_files.attach(invitation_file)
    @project.participation_certificate_files.attach(certificate_file)
  
    assert_equal 1, @project.participants_files.count
    assert_equal 1, @project.invitation_files.count
    assert_equal 1, @project.participation_certificate_files.count

    assert_difference('Project.count', -1) do
      @project.destroy
    end
 
    assert_not Project.exists?(@project.id)

    assert_empty @project.participants_files
    assert_empty @project.invitation_files
    assert_empty @project.participation_certificate_files
  end
  
  test "should remove file" do
    file = fixture_file_upload(Rails.root.join('test/fixtures/files/test_file.txt'))
    @project.participants_files.attach(file)

    assert_difference('@project.participants_files.count', -1) do
      delete remove_file_project_url(@project, file_type: 'participants_files', attachment_id: @project.participants_files.first.id)
    end

    assert_redirected_to edit_project_url(@project)
  end
  
  test "should filter projects by search" do
    get projects_url, params: { search: "Fortbildung" }
    assert_response :success
    assert_match projects(:one).project_title, @response.body
    assert_match projects(:two).project_title, @response.body
    assert_match projects(:three).project_title, @response.body

    get projects_url, params: { search: "Unbekannt" }
    assert_response :success
    assert_no_match projects(:one).project_title, @response.body
    assert_no_match projects(:two).project_title, @response.body
    assert_no_match projects(:three).project_title, @response.body
  end

  test "should handle invalid project_type filter" do
    get projects_url, params: { project_type: "InvalidType" }
    assert_response :bad_request
    assert_includes @response.body, "Invalid project type"
  end

  test "should get archived projects" do
    @project.update(archived: true)  # Projekt archivieren
    
    get archived_projects_url
    assert_response :success
  end
  

  test "should return alert for invalid file type" do
    delete remove_file_project_url(@project, file_type: 'invalid_type', attachment_id: 123)
    assert_redirected_to edit_project_url(@project)
    assert_equal 'Ungültiger Dateityp.', flash[:alert]
  end

  test "should show file" do
    file = fixture_file_upload(Rails.root.join('test/fixtures/files/test_file.txt'))
    @project.participants_files.attach(file)

    get show_file_project_url(@project, file_type: 'participants_files', attachment_id: @project.participants_files.first.id)
    assert_response :success
  end

  test "should render 404 if file not found" do
    get show_file_project_url(@project, file_type: 'participants_files', attachment_id: 123)
    assert_response :not_found
  end
end