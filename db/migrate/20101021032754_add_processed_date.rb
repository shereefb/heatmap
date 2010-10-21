class AddProcessedDate < ActiveRecord::Migration
  def self.up
    add_column :logs, :processed_at, :datetime, :default => nil
    add_column :logs, :heatmap, :text, :default => nil
    add_column :logs, :duration, :integer, :default => nil
  end

  def self.down
    remove_column :logs, :processed_at
    remove_column :logs, :heatmap
    remove_column :logs, :duration
  end
end
