class AvatarsController < ApplicationController
  before_action :require_user_logged_in!

  def new
  end

  def update
    if Current.user.update(avatar_params)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Current.user.avatar.purge
    redirect_to root_path
  end

  private

  def avatar_params
    params.require(:user).permit(:avatar)
  end
end
