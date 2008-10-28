class Security < ActiveRecord::Base
  has_many :fldates, :dependent => :delete_all
  validates_uniqueness_of :cusip, :scope=> [:date,:fund]
  has_and_belongs_to_many :users
  #before_destroy { |record| Fldates.destroy_all "security_id = #{record.id}" }
  

 end
