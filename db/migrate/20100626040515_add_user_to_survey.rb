class AddUserToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :user_id, :integer
  end

  def self.down
    remove_column :surveys, :user_id
  end
end
