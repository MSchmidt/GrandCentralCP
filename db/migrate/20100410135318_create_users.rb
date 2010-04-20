class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable
      t.boolean :admin, :null=>false, :default=>false
      
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
    add_index :users, :admin
  end

  def self.down
    drop_table :users
  end
end
