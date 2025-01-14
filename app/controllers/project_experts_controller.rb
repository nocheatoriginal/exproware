class ProjectExpertsController < ApplicationController
  before_action :set_project

  def create
    expert = Expert.find(params[:expert_id])
    @project.experts << expert unless @project.experts.include?(expert)
    render_expert_list
  end

  def destroy
    expert = Expert.find(params[:id])
    @project.experts.delete(expert)
    render_expert_list
  end

  def available_experts
    @experts = Expert.where.not(id: @project.experts.pluck(:id)).where(role: :user)
    render json: @experts
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def render_expert_list
    render partial: 'projects/expert_list', locals: { project: @project }
  end
end