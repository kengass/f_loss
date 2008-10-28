class AddDefaultViewdate < ActiveRecord::Migration
  def self.up
    if !Viewdate.find(:first)
      Viewdate.create(:vdate => '2008-06-01')
    end
  end

  def self.down
  end
end
