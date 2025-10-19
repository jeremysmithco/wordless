class HomeController < ApplicationController
  def index
    redirect_to [:new, :avatar] if user_logged_in? && !Current.user.avatar.present?
  end
end
