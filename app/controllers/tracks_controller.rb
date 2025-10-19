class TracksController < ApplicationController
  before_action :require_user_logged_in!, only: :create

  def create
    track = Track.create(user: Current.user)

    redirect_to track_path(track)
  end

  def show
    @track = Track.find_by!(number: params[:id])
  end
end
