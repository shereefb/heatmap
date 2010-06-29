class AddDescColumnsToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :qdesc, :text
    add_column :questions, :adesc, :text
    add_column :question_groups, :qdesc, :text
    add_column :question_groups, :adesc, :text
  end

  def self.down
    remove_column :questions, :qdesc
    remove_column :questions, :adesc
    remove_column :question_groups, :qdesc
    remove_column :question_groups, :adesc
  end
end
