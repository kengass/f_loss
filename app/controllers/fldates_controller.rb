class FldatesController < ApplicationController
  # GET /fldates
  # GET /fldates.xml
    before_filter :check_administrator_role
  
  active_scaffold :fldates

  active_scaffold :fldates do |config|
    config.list.per_page = 80
    config.list.columns = [:security, :cdr, :severity, :f_loss, :principal, :writedown]    
    config.list.columns.exclude :created_at, :updated_at
    config.columns[:f_loss].label = 'First Loss Date'    
  end
end
