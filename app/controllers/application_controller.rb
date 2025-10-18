class ApplicationController < ActionController::Base
  before_action :set_current_user
  helper_method :user_logged_in?, :show_analytics?

  protected

  def set_current_user
    Current.user = if session[:user_id].present?
      User.find_by!(id: session[:user_id])
    else
      GuestUser.new
    end
  end

  def require_user_logged_in!
    redirect_to [:new, :sessions], alert: 'You must be logged in' unless user_logged_in?
  end

  def user_logged_in?
    Current.user.is_a?(User)
  end
end
