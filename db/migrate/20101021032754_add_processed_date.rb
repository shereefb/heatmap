class AddProcessedDate < ActiveRecord::Migration
  def self.up
    add_column :logs, :processed_at, :datetime, :default => nil
    add_column :logs, :heatmap, :default => nil
    add_column :logs, :duration, :default => nil
  end

  def self.down
    remove_column :logs, :processed_at
    remove_column :logs, :heatmap
    remove_column :logs, :duration
  end
end
