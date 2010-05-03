# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def is_admin?
    current_user.admin
  end
end
