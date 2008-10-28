class Fldate < ActiveRecord::Base
  belongs_to :security
  validates_uniqueness_of :security_id, :scope=> [:cdr,:severity]
  
end
