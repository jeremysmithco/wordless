class RecordingsController < ApplicationController
  before_action :require_user_logged_in!
  before_action :set_track, only: :create

  def create
    @recording = Recording.new(recording_params.merge(track: @track, user: Current.user))
    @recording.save
    redirect_to @recording.track
  end

  def destroy
    @recording = Recording.find_by!(id: params[:id], user: Current.user)
    @recording.destroy
    redirect_to @recording.track
  end

  private

  def set_track
    @track = Track.find_by!(number: params[:track_id])
  end

  def recording_params
    params.require(:recording).permit(:file, :duration)
  end
end
