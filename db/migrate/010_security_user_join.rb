class SecurityUserJoin < ActiveRecord::Migration
  def self.up
    create_table :securities_users, :id => false do |t|
      t.integer :security_id
      t.integer :user_id
    end   
  end

  def self.down
   drop_table :securities_users    
  end
end
