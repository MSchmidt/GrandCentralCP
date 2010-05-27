class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.integer   :user_id
      t.string    :fqdn
      t.string    :mount_point
      t.boolean   :php,         :default => false, :null => false
      t.boolean   :rails,       :default => false, :null => false
      t.boolean   :saved,       :default => false, :null => false
      t.integer   :saved_by,    :null => false
      t.boolean   :pending,     :default => true, :null => false
      t.integer   :copy_of,     :default => nil, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
