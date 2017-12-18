class ChangeDataTypeForDate < ActiveRecord::Migration
    def self.up
        change_column(:events, :date, :date)
    end
    def self.down
        change_column(:events, :date, :datetime)
    end
end
