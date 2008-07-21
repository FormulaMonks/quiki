require 'yaml'

class OldPage < ActiveRecord::Base
  set_table_name 'pages'
  acts_as_versioned :foreign_key => 'page_id', :table_name => 'page_versions'
end

class OldCodeBlock
  attr_accessor :language, :code

  def initialize(language, code)
    self.language = language
    self.code = code
  end
end

class CreateCodeBlocks < ActiveRecord::Migration
  def self.up
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
    
    OldPage.find(:all).each do |page|
      page.versions.each do |version|
        unless version.code_blocks.nil?
          code_blocks = YAML.load(version.code_blocks.gsub(/object:CodeBlock/, 'object:OldCodeBlock'))
          code_blocks.each do |code_block|
            if code_block.is_a?(OldCodeBlock) && page.version != version.version
              new_block = CodeBlock.new :code => code_block.code, :language => code_block.language, :theme => Page::CODE_THEME
              new_block.version = version.version
              new_block.page_id = page.id
              new_block.save!
            end
          end
        end
      end
      unless page.code_blocks.nil?
        code_blocks = YAML.load(page.code_blocks.gsub(/object:CodeBlock/, 'object:OldCodeBlock'))
        code_blocks.each do |code_block|
          if code_block.is_a?(OldCodeBlock)
            new_block = CodeBlock.new :code => code_block.code, :language => code_block.language, :theme => Page::CODE_THEME
            new_block.version = page.version
            new_block.page_id = page.id
            new_block.save!
          end
        end
      end
    end
    
    remove_column :pages, :code_blocks
    remove_column :page_versions, :code_blocks
  end

  def self.down
    add_column :pages, :code_blocks, :text
    add_column :page_versions, :code_blocks, :text
    drop_table :code_blocks
  end
end
