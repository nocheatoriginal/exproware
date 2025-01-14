class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, except: :show
  before_action :authorize_show_access, only: :show
  before_action :set_dropdown_options, only: [:index, :update]

  def index
    @users = User.all
    @user = User.new
    @only_admin = User.admin.count <= 1
    @links = OneTimeLink.all
  end

  def new
    @user = User.new
  end

  # Seite zum Bearbeiten eines Benutzers
  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  #def create
  #  @user = User.new(user_params)
  #  if @user.save
  #    redirect_to admin_users_path, notice: "User created successfully."
  #  else
  #    redirect_to admin_users_path, alert: "Failed to create user."
  #  end
  #end

  def create
    @user = User.new(user_params)

    if @user.email.blank?
      redirect_to admin_users_path, alert: "E-Mail-Adresse ist erforderlich."
      return
    end
    
    if params[:user][:user_type] == 'expert_invite'
      OneTimeLink.where(email: @user.email).delete_all
      link = OneTimeLink.create!(expires: 14.days.from_now, email: @user.email, used: false)
    
      UserMailer.send_registration_email(@user.email, link).deliver_now

      base_url = Rails.application.config.base_url
      @register_url = "#{base_url}/signup/#{link.token}"

      redirect_to admin_users_path, notice: "Registrierungseinladungslink #{@register_url} wurde erfolgreich an #{link.email} gesendet."
    else
      if @user.save
        flash[:notice] = "Nutzer*in wurde erfolgreich erstellt."
      else
        redirect_to admin_users_path, notice: "Aktion fehlgeschlagen."
      end
    end    
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated
      successfully."
    else
      redirect_to admin_users_path, alert: "Failed to update user."
    end
  end

  def update_role
    @user = User.find(params[:id])
    if @user.update(role: params[:user][:role])
      redirect_to admin_users_path, notice: "User role updated successfully."
    else
      redirect_to admin_users_path, alert: "Failed to update user role."
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_users_path, notice: "User wurde erfolgreich gelöscht."
    else
      redirect_to admin_users_path, alert: "User konnte nicht gelöscht werden."
    end
  end

  def delete_one_time_link
    link = OneTimeLink.find_by(email: params[:email])
    if link
      link.destroy
      redirect_to admin_users_path, notice: "Einladungslink wurde erfolgreich gelöscht."
    else
      redirect_to admin_users_path, alert: "Kein Einladungslink für diese E-Mail gefunden."
    end
  end  

  private

  def set_dropdown_options
    @roles = User.roles.keys
  end

  def authorize_admin
    unless current_user.admin?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def authorize_show_access
    @user = User.find(params[:id])
    
    unless current_user.admin? || current_user == @user
      redirect_to root_path, alert: "You can only view your own profile."
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end
end
