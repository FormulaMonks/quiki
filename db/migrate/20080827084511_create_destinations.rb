class CreateDestinations < ActiveRecord::Migration
  def self.up
    create_table :destinations do |t|
      t.string :name
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :destinations
  end
end
