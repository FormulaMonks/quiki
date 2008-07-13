class AddTitleToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :title, :string, :null => false
    add_column :page_versions, :title, :string, :null => false
  end

  def self.down
    remove_column :pages, :title
    remove_column :page_versions, :title
  end
end
