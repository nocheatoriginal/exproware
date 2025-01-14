class HomeController < ApplicationController
  def index
  end

  before_action :authenticate_user!
  before_action :check_admin, only: [:destroy]

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice
  end

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
