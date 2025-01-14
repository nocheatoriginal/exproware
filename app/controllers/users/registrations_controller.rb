class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_token, only: [:new]

  def create
    if params[:user][:email] != session[:token_email]
      flash[:alert] = "Invalid Email!"
      not_allowed_route and return
    end
  
    super do |resource|
      if resource.save
        OneTimeLink.find_by(email: resource.email)&.update(used: true)
        @user = User.find_by(email: resource.email)
        @expert = Expert.find_by(email: resource.email)
        if @expert
          @user.update(expert_id: @expert.id, initialized: true)
        end
      else
        flash[:alert] = resource.errors.full_messages.join(", ")
      end
    end
  end
  

    def handle_token
      token = params[:token]
      link = OneTimeLink.find_by(token: token)

      if link
        redirect_to new_user_registration_path(token: token)
      else
        flash[:alert] = "Missing Token!"
        not_found_route
      end
    end

    def check_token
      token = params[:token]
      link = OneTimeLink.find_by(token: token)
    
      if link && link.active?
        session[:token_email] = link.email
      else
        flash[:alert] = "Missing or invalid Token!"
        not_found_route
      end
    end
end

# frozen_string_literal: true

#class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
# end