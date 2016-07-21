class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    # I18n.locale = current_user.try(:locale) || I18n.default_locale
  end

  def self.default_url_options
    { locale: I18n.locale }
  end

  def authenticate_any!
    if admin_signed_in?
      true
    else
      authenticate_user!
    end
  end

  def after_sign_in_path_for(resource)
    if current_admin
      admins_test_path
    else
      root_path
    end
  end
end
