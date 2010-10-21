class CreateVideoTable < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :youtube_id
      t.text   :heatmap
      t.integer :duration
      t.integer :user_id
      t.float :total_views
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
