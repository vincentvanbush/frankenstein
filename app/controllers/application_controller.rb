class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:error] = I18n.t 'pundit.user_not_authorized'
    if user_signed_in?
      render '/visitors/index', status: 401
    else
      render '/devise/sessions/new', status: 401
    end
  end
end
