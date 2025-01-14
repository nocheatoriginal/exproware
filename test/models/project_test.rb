require "test_helper"
class ProjectTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @participants_file = fixture_file_upload('test/fixtures/files/20241011_Infos_FITI.pdf', 'application/pdf')
    @invitation_file = fixture_file_upload('test/fixtures/files/team_manifest.pdf', 'application/pdf')
    @participation_certificate_file = fixture_file_upload('test/fixtures/files/Metriken.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

    @valid_project_attributes = {
      project_title: projects(:one).project_title,
      thematic_focus: projects(:one).thematic_focus,
      start_date: projects(:one).start_date,
      end_date: projects(:one).end_date,
      project_type: projects(:one).project_type,
      client: projects(:one).client,
      location: projects(:one).location,
      invitation_status: projects(:one).invitation_status,
      participation_certificate_status: projects(:one).participation_certificate_status
    }
  end

  test "should create project with files" do
    project = Project.new(@valid_project_attributes)
    project.participants_files.attach(@participants_file)
    project.invitation_files.attach(@invitation_file)
    project.participation_certificate_files.attach(@participation_certificate_file)

    assert project.save
    assert_equal 1, project.participants_files.count
    assert_equal 1, project.invitation_files.count
    assert_equal 1, project.participation_certificate_files.count
  end

  test "should read project attributes correctly" do
    project = projects(:one)
    assert_equal "Fortbildung praxisorientierte Ausbildung Juli 2025", project.project_title
    assert_equal "Ausbildung, Handwerker", project.thematic_focus
    assert_equal Date.today, project.start_date
    assert_equal Date.today + 1.month, project.end_date
    assert_equal "delegation_visit", project.project_type
    assert_equal "Beijing Institute xyz", project.client
    assert_equal "München, Deutschland", project.location
    assert_equal "versendet", project.invitation_status
    assert_equal "versendet", project.participation_certificate_status
  end

  test "should destroy project with files" do
    project = projects(:one)
    project.participants_files.attach(@participants_file)
    project.invitation_files.attach(@invitation_file)
    project.participation_certificate_files.attach(@participation_certificate_file)

    project.participants_files.purge
    project.invitation_files.purge
    project.participation_certificate_files.purge

    assert project.participants_files.empty?
    assert project.invitation_files.empty?
    assert project.participation_certificate_files.empty?

    assert_difference("Project.count", -1) { project.destroy }
    assert_not project.persisted?
  end

  test "should not save project without required attributes" do
    [
      { project_title: nil, error_message: "Saved the project without a project_title" },
      { thematic_focus: nil, error_message: "Saved the project without a thematic_focus" },
      { start_date: nil, error_message: "Saved the project without a start_date" },
      { end_date: nil, error_message: "Saved the project without an end_date" },
      { project_type: nil, error_message: "Saved the project without a project_type" },
      { client: nil, error_message: "Saved the project without a client" },
      { location: nil, error_message: "Saved the project without a location" },
      { invitation_status: nil, error_message: "Saved the project without an invitation_status" },
      { participation_certificate_status: nil, error_message: "Saved the project without a participation_certificate_status" }
    ].each do |attr|
      project = Project.new(@valid_project_attributes.except(:project_title, :thematic_focus, :start_date, :end_date, :project_type, :client, :location, :invitation_status, :participation_certificate_status).merge(attr.except(:error_message)))
      assert_not project.save, attr[:error_message]
    end
  end
  
  test "new project should have archived set to false by default" do
    project = Project.new(@valid_project_attributes)
    assert_not project.archived
  end
end