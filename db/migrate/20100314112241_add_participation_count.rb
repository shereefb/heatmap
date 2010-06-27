class AddParticipationCount < ActiveRecord::Migration
  def self.up
    add_column :surveys, :participations_count, :integer, :default => 0
    add_column :questions, :number, :integer
    add_column :questions, :suggester_id, :integer
    add_index :questions, :suggester_id
    add_column :questions, :approved, :boolean, :default => false
    add_index :questions, :approved
  end

  def self.down
    remove_column :surveys, :participations_count
    remove_column :questions, :number
    remove_index :questions, :suggester_id
    remove_column :questions, :suggester_id
    remove_index :questions, :approved
    remove_column :questions, :approved
  end
end
