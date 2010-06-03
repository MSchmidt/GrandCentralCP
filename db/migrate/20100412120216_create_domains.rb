class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.integer   :user_id
      t.string    :fqdn
      t.string    :mount_point
      t.boolean   :php,         :default => false, :null => false
      t.boolean   :rails,       :default => false, :null => false
      t.integer   :workbench_x
      t.integer   :workbench_y

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
