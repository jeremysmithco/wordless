class CreateTracks < ActiveRecord::Migration[8.0]
  def change
    create_table :tracks do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :number, index: { unique: true }

      t.timestamps
    end
  end
end
