class AddResetTokenTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_token_time, :datetime
  end
end
