class AddBDescToQuestionGroup < ActiveRecord::Migration
  def self.up
    add_column :question_groups, :bdesc, :text
    add_column :question_groups, :variation, :string
    add_column :question_groups, :section_id, :integer
    add_column :question_groups, :is_mandatory, :boolean, :default => false
  end

  def self.down
    remove_column :question_groups, :bdesc
    remove_column :question_groups, :variation
    remove_column :section_id
    remove_column :is_mandatory
  end
end
