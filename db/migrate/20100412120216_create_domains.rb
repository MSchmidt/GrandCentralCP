class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.integer   :user_id
      t.string    :fqdn
      t.string    :mount_point
      t.boolean   :php, :default=>false
      t.boolean   :rails, :default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
