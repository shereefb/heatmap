class AddSurveyPermalink < ActiveRecord::Migration
  def self.up
    add_column :surveys, :permalink, :string
    add_index :surveys, :permalink
    
    Survey.all.each(&:save)
  end

  def self.down
    remove_index :surveys, :permalink
    remove_column :surveys, :permalink
  end
end
