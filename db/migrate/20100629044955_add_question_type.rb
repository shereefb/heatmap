class AddQuestionType < ActiveRecord::Migration
  def self.up
    add_column :questions, :variation, :string
  end

  def self.down
    drop_column :questions, :variation
  end
end
