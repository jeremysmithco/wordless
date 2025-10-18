class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :auth_token, null: false, index: { unique: true }
      t.datetime :auth_token_expires_at, null: false

      t.timestamps
    end
  end
end
