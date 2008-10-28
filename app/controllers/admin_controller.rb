#---
# Excerpted from "Rails Recipes"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_rr for more book information.
#---
class AdminController < ApplicationController

  before_filter :check_authentication, :except => [:signin]

  def check_authentication
    unless session[:user]
      session[:intended_action] = action_name
      session[:intended_controller] = controller_name      
      redirect_to :action => "signin"
    end
  end

  def signin
    if request.post?
      user = User.find(:first, :conditions=> ['username = ?', params[:username]])
      if user.blank? ||
          Digest::SHA256.hexdigest(params[:password]+ user.password.salt) != user.password_hash
        raise "Username or password invalid"
      end
      session[:user] = user.id
      redirect_to :action => session[:intended_action],
        :controller => session[:intended_controller]
    end
  end
end
