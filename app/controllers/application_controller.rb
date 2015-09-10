class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_admin, :current_doctor, :current_patient

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

    def configure_permitted_parameters
      allowed_params = [:first_name, :last_name, :pesel, :pwz, :address]
      devise_parameter_sanitizer.for(:account_update) << allowed_params
      devise_parameter_sanitizer.for(:sign_up) << allowed_params
    end

  private

    def current_admin
      @current_admin ||= current_user if user_signed_in? and current_user.is_a? Admin
    end

    def current_doctor
      @current_doctor ||= current_user if user_signed_in? and current_user.is_a? Doctor
    end

    def current_patient
      @current_patient ||= current_user if user_signed_in? and current_user.is_a? Patient
    end

    def admin_signed_in?
      current_admin.present?
    end

    def doctor_signed_in?
      current_doctor.present?
    end

    def patient_signed_in?
      current_patient.present?
    end

    def user_not_authorized
      flash[:error] = I18n.t 'pundit.user_not_authorized'
      if user_signed_in?
        render '/visitors/index', status: 401
      else
        render '/devise/sessions/new', status: 401
      end
    end

end
