class DoctorPolicy < UserPolicy
  def permitted_attributes
    @user_attrs += [:pwz]
    super
  end
end
