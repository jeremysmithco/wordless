class AccountsController < ApplicationController
  before_action :require_user_logged_in!

  def show
  end
end
