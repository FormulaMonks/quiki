class CreatePublishings < ActiveRecord::Migration
  def self.up
    create_table :publishings do |t|
      t.integer :destination_id
      t.integer :page_version_id
      t.timestamp :created_at
    end
    
    add_index :publishings, :destination_id
    add_index :publishings, :page_version_id
  end

  def self.down
    drop_table :publishings
  end
end
