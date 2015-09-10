class DeviseCustom::PatientRegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def initialize
    @model_class = Patient
    super
  end

  def authenticate_scope!
    send(:authenticate_user!, force: true)
    self.resource = send(:current_user)
  end
end
