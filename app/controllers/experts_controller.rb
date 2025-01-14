# app/controllers/experts_controller.rb
class ExpertsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_uninitialized, only: %i[ index show edit update destroy ]
  before_action :check_user_initialized, only: %i[ index new create ]
  before_action :set_expert, only: %i[ show edit update destroy ]
  before_action :set_expert_by_unique_id, only: [:edit_with_password, :verify_password]

  def edit_with_password
    # Zeigt die Passwort-Eingabeseite an
  end

  def verify_password
    if @expert.authenticate(params[:password])
      puts "Password authentication successful"
      session[:authenticated_expert_id] = @expert.id
      puts "Session authenticated_expert_id set to: #{@expert.id}"
      redirect_to edit_expert_path(@expert), notice: "Passwort erfolgreich verifiziert. Sie können jetzt Ihre Daten bearbeiten."
    else
      puts "Password authentication failed"
      flash[:alert] = "Falsches Passwort"
      render :edit_with_password
    end
  end

  def index
    @experts = Expert.all
  end

  def show
    @expert = Expert.find(params[:id])
    @user = current_user

    if @user.user? && @user.expert_id != @expert.id
      redirect_to expert_path(@user.expert_id), notice: "Sie haben nicht die benötigten Berechtigungen, um auf dieses Profil zuzugreifen."
    end
  end

  # GET /experts/new
  def new
    @expert = Expert.new
  end

  def edit
    if session[:authenticated_expert_id] == @expert.id || current_user
      # Zeigt die Bearbeitungsseite an
    else
      redirect_to edit_expert_with_password_path(@expert.unique_id)
    end
  end

  def create
    @expert = Expert.new(expert_params)
  
    respond_to do |format|
      if @expert.save
        if current_user.admin?
          OneTimeLink.where(email: @expert.email).delete_all
          link = OneTimeLink.create!(expires: 14.days.from_now, email: @expert.email, used: false)
          UserMailer.send_registration_email(@expert.email, link).deliver_now
        end

        if current_user.user?
          current_user.update!(expert_id: @expert.id, initialized: true)
        end
  
        format.html { redirect_to @expert, notice: "Experten-Profil erstellt und Einladungslink an #{@expert.email} gesendet." }
        format.json { render :show, status: :created, location: @expert }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def update
    respond_to do |format|
      if @expert.update(expert_params)
        format.html { redirect_to @expert, notice: "Expert was successfully updated." }
        format.json { render :show, status: :ok, location: @expert }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @expert.destroy!

    respond_to do |format|
      format.html { redirect_to experts_path, status: :see_other, notice: "Expert was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_expert
    @expert = Expert.find(params[:id])
  end

  def set_expert_by_unique_id
    @expert = Expert.find_by(unique_id: params[:unique_id])
    redirect_to root_path, alert: "Expert nicht gefunden" unless @expert
  end

  def expert_params
    params.require(:expert).permit(:first_name, :last_name, :academic_title, :salary, :travel_willingness, :profile_image, :biography, :email, category_ids: [])
  end

    def check_user_initialized
      if (current_user.user? && current_user.initialized?)
        redirect_to root_path, alert: "Nicht autorisiert."
      end
    end

    def check_user_uninitialized
      if (current_user.user? && !current_user.initialized?)
        redirect_to root_path, alert: "Nicht autorisiert."
      end
    end
end
