class CreateViewdates < ActiveRecord::Migration
  def self.up
    create_table :viewdates do |t|
      t.date :vdate

      t.timestamps
    end
  end

  def self.down
    drop_table :viewdates
  end
end
