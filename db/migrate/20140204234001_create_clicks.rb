class CreateClicks < ActiveRecord::Migration
  def self.up
    create_table :clicks do |t|
      t.integer :link_id
      t.timestamps
    end
  end

  def self.down
    drop_table :clicks
  end
end