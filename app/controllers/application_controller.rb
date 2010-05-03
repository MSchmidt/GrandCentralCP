# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authenticate_user!
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  layout :layout_by_resource
  
  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end
  
  def is_admin?
    current_user.admin
  end
  
  def is_admin
    unless current_user.admin
      redirect_to user_root_url
    end
  end
end
