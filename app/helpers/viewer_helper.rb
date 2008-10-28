module ViewerHelper
  
  def cusip_column(record)
    link_to(h(record.cusip), :action => :index, :controller => 'viewer', :id => record.id)
  end
end
