# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'cdda68ff4db02c5c8825625c77a37fe1'
  
  include AuthenticatedSystem
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  before_filter :login_required
  before_filter :Get_Vdate 
  
  def Get_Vdate
      @vdate = Viewdate.find(:first).vdate
  end
  
  require 'roo'
  require 'pp' 
  
end
