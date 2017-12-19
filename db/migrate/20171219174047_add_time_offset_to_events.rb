class AddTimeOffsetToEvents < ActiveRecord::Migration
  def change
    add_column :events, :time_offset, :integer
  end
end
