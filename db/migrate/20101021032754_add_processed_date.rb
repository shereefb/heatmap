class AddProcessedDate < ActiveRecord::Migration
  def self.up
    add_column :logs, :processed_at, :datetime, :default => nil
  end

  def self.down
    remove_column :logs, :processed_at
  end
end
