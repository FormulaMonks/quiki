class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :path, :null => false, :uniq => true
      t.text   :body
      t.text   :rendered
      t.timestamps
    end
    
    add_index :pages, :path
  end

  def self.down
    drop_table :pages
  end
end
