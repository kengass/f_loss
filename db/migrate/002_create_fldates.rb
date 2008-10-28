class CreateFldates < ActiveRecord::Migration
  def self.up
    create_table :fldates do |t|
      t.integer :security_id
      t.decimal :cdr, :precision => 5, :scale => 1
      t.decimal :severity, :precision => 5, :scale => 1
      t.date :f_loss
      t.decimal :principal, :precision =>15, :scale => 2
      t.decimal :writedown, :precision =>15, :scale => 2            

      t.timestamps
    end
  end

  def self.down
    drop_table :fldates
  end
end
