class CreateCodeBlocks < ActiveRecord::Migration
  def self.up
    remove_column :pages, :code_blocks
    remove_column :page_versions, :code_blocks
    
    create_table :code_blocks do |t|
      t.integer  :page_id
      t.integer  :version
      t.string   :language
      t.text     :code
      t.text     :highlighted
      t.string   :theme
      t.datetime :created_at
    end
    
    add_index :code_blocks, :page_id
    add_index :code_blocks, :version
    add_index :code_blocks, :language
    add_index :code_blocks, :created_at
  end

  def self.down
    add_column :pages, :code_blocks, :text
    add_column :page_versions, :code_blocks, :text
    drop_table :code_blocks
  end
end
