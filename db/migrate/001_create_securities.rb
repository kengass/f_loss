class CreateSecurities < ActiveRecord::Migration
  def self.up
    create_table :securities do |t|
      t.string :cusip
      t.string :fund
      t.date :date
      t.string :title
      t.string :filename      
      t.string :moodys, :default => "NA"
      t.string :s_p, :default => "NA"
      t.string :fitch, :default => "NA"
      t.decimal :ce_orig, :precision => 8, :scale => 2
      t.decimal :ce_cur, :precision => 8, :scale => 2
      t.decimal :qtr_cdr, :precision => 8, :scale => 2
      t.decimal :qtr_severity, :precision => 8, :scale => 2
      t.string :forclosure_reo
      t.string :delinq_30_60_90     
      t.integer :cpr      

      t.timestamps
    end
  end

  def self.down
    drop_table :securities
  end
end
