class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    @tracks = Track.where(user: @user).order(created_at: :desc)
  end
end
