class PatientPolicy < UserPolicy
  def permitted_attributes
    @user_attrs += [:pesel, :address]
    super
  end
end
