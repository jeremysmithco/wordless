class RecordingsController < ApplicationController
  def index
    @recordings = Recording.order(created_at: :desc)
  end

  def create
    @recording = Recording.new(recording_params)

    if @recording.save
      render json: { id: @recording.id, success: true }, status: :created
    else
      render json: { errors: @recording.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @recording = Recording.find(params[:id])
    @recording.destroy
    redirect_to recordings_path, notice: "Recording deleted."
  end

  private

  def recording_params
    params.require(:recording).permit(:file, :duration)
  end
end
