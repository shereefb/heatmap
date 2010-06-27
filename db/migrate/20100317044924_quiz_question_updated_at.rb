class SurveyQuestionUpdatedAt < ActiveRecord::Migration
  def self.up
    add_column :surveys, :questions_updated_at, :datetime
    add_index :surveys, :questions_updated_at
    
    add_column :surveys, :last_viewed, :datetime
    add_index :surveys, :last_viewed
  end

  def self.down
    remove_index :surveys, :questions_updated_at
    remove_column :surveys, :questions_updated_at
    
    remove_index :surveys, :last_viewed
    remove_column :surveys, :last_viewed
  end
end
