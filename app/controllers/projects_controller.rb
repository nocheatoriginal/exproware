class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin_or_read_only
  before_action :set_project, only: %i[show edit update destroy remove_file show_file]
  before_action :set_dropdown_options, only: %i[new edit create update]
  before_action :set_expert_options, only: %i[ new edit create update ]

  # GET /projects or /projects.json
  def index
    @projects = Project.where(archived: false)
    @archived_projects = Project.where(archived: true)
    
    if params[:search].present?
      @projects = @projects.where("project_title LIKE :query OR client LIKE :query", query: "%#{params[:search]}%")
    end

    if params[:project_type].present?
      if Project.project_types.keys.include?(params[:project_type])
        @projects = @projects.where(project_type: params[:project_type])
      else
        render plain: "Invalid project type", status: :bad_request
        return
      end
    end
  end

  # GET /archived_projects
  def archived
    @projects = Project.where(archived: true)

    if params[:project_type].present?
      if Project.project_types.keys.include?(params[:project_type])
        @projects = @projects.where(project_type: params[:project_type])
      else
        render plain: "Invalid project type", status: :bad_request
        return
      end
    end
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: "Projekt wurde erfolgreich erstellt." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    if params[:project][:project_type].present?
      if Project.project_types.keys.include?(params[:project][:project_type])
        @project.project_type = params[:project][:project_type]
      else
        flash[:alert] = "Invalid project type"
        render :edit, status: :unprocessable_entity and return
      end
    end
  
    if params[:project].key?(:expert_ids)
      @project.expert_ids = params[:project][:expert_ids].reject(&:blank?)
    elsif @project.archived? && params[:project][:archived] == "false"
      @project.expert_ids = @project.expert_ids
    else
      @project.expert_ids = []
    end
  
    respond_to do |format|
      if @project.update(project_params.except(:project_type, :expert_ids))
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.project_experts.destroy_all
    @project.participants_files.each { |attachment| attachment.purge if attachment.blob.present? }
    @project.invitation_files.each { |attachment| attachment.purge if attachment.blob.present? }
    @project.participation_certificate_files.each { |attachment| attachment.purge if attachment.blob.present? }

    if @project.destroy
    
    respond_to do |format|
        format.html { redirect_to projects_url, notice: "Project was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to projects_url, alert: "Projekt konnte nicht gelöscht werden." }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/:id/remove_file/:attachment_id
  def remove_file
    file_type = params[:file_type]
    attachment_id = params[:attachment_id]

    file = case file_type
           when 'participants_files' then @project.participants_files.find_by(id: attachment_id)
           when 'invitation_files' then @project.invitation_files.find_by(id: attachment_id)
           when 'participation_certificate_files' then @project.participation_certificate_files.find_by(id: attachment_id)
           else
             return redirect_to edit_project_url(@project), alert: "Ungültiger Dateityp."
           end

    if file
      file.purge
      redirect_to edit_project_url(@project), notice: "Datei wurde erfolgreich entfernt."
    else
      redirect_to edit_project_url(@project), alert: "Die Datei konnte nicht gefunden werden."
    end
  end

  # GET /projects/:id/show_file/:attachment_id
  def show_file
    file_type = params[:file_type]
    attachment_id = params[:attachment_id]

    file = case file_type
           when 'participants_files' then @project.participants_files.find_by(id: attachment_id)
           when 'invitation_files' then @project.invitation_files.find_by(id: attachment_id)
           when 'participation_certificate_files' then @project.participation_certificate_files.find_by(id: attachment_id)
           else
             nil
           end

    if file
      send_data file.download, filename: file.filename.to_s, disposition: 'inline'
    else
      render_404
    end
  rescue ActiveRecord::InvalidForeignKey
    flash[:alert] = "Cannot delete project due to existing dependencies."
    redirect_to projects_url
  end
  

  private
    def set_expert_options
      @experts = Expert.joins(:user).where(users: { role: :user })
    end

  def set_dropdown_options
    @project_types = Project.project_types.keys
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :project_title, 
      :thematic_focus, 
      :start_date, 
      :end_date, 
      :project_type, 
      :client, 
      :location,
      :archived, 
      :invitation_status, 
      :participation_certificate_status,
      participants_files: [],
      invitation_files: [],
      participation_certificate_files: [],
      expert_ids: [])
  end

  def authorize_admin_or_read_only
    redirect_to root_path, alert: "Nicht autorisiert." unless current_user.admin? || current_user.read_only?
  end
end