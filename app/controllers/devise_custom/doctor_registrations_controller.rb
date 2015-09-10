class DeviseCustom::DoctorRegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def initialize
    @model_class = Doctor
    super
  end

  def authenticate_scope!
    send(:authenticate_user!, force: true)
    self.resource = send(:current_user)
  end
end
