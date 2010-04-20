class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.authenticatable
      t.boolean :admin, :null=>false, :default=>false
      
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
  end
end
