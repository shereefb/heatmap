class CreateLogTable < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string    :ip
      t.string    :youtube_id
      t.string    :timelog
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
