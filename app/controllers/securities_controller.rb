class SecuritiesController < ApplicationController
  # GET /securities
  # GET /securities.xml
  before_filter :check_administrator_role  
active_scaffold :securities

  
active_scaffold :securities do |config|
  config.list.sorting = { :cusip => :desc }
  config.list.columns.exclude :created_at, :updated_at
  config.list.columns = [:cusip, :fund, :date, :title, :ce_cur, :ce_orig,:cpr, :fitch, :s_p, :moodys, :forclosure_reo, :delinq_30_60_90, :fldates]
  end    
  
end
