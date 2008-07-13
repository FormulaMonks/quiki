class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :name
    end
    
    [ :pages, :page_versions ].each do |table|
      add_column table, :section_id, :integer
      add_index table, :section_id
    end
  end

  def self.down
    drop_table :sections
    [ :pages, :page_versions ].each do |table|
      remove_column table, :section_id
    end
  end
end
