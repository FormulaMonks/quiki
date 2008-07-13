class AddParserToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :parser, :string
  end

  def self.down
    remove_column :pages, :parser
  end
end
