class AddCodeBlocksToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :code_blocks, :text
    add_column :page_versions, :code_blocks, :text
  end

  def self.down
    remove_column :pages, :code_blocks
    remove_column :page_versions, :code_blocks
  end
end
