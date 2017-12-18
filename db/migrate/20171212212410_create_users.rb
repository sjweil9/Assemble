class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first
      t.string :last
      t.string :email
      t.string :location
      t.string :state
      t.string :password_digest
      t.boolean :email_confirmed
      t.string :confirm_token
      t.boolean :account_locked
      t.integer :login_attempts
      t.datetime :last_attempt
      t.string :unlock_token

      t.timestamps null: false
    end
  end
end
