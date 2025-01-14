class OneTimeLinksController < ApplicationController
  def sign_up
    @link = OneTimeLink.find_by(token: params[:token])

    if @link&.active? && !@link.expired?
      session[:token_email] = @link.email
      redirect_to new_user_registration_path(token: @link.token)
    else
      flash[:alert] = "Dieser Link ist ungültig oder abgelaufen."
      redirect_to root_path
    end
  end
end