class SessionsController < ApplicationController
  def new
    user = User.find_by(auth_token: params[:token], auth_token_expires_at: Time.current..)

    if user.present?
      reset_session
      session[:user_id] = user.id
    end

    redirect_to root_path
  end

  def destroy
    reset_session

    redirect_to root_path
  end
end
