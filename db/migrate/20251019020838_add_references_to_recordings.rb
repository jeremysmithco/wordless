class AddReferencesToRecordings < ActiveRecord::Migration[8.0]
  def change
    add_reference :recordings, :track
    add_reference :recordings, :user
  end
end
