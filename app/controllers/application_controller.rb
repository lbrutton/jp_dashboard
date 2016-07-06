class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def authenticate_any!
    if admin_signed_in?
      true
    else
      authenticate_user!
    end
  end
end
