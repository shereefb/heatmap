class RenameSurveySection < ActiveRecord::Migration
  def self.up
    rename_column :questions, :survey_section_id, :section_id
  end

  def self.down
    rename_column :questions, :section_id, :survey_section_id
  end
end
