class AppointmentPolicy < FullyRestrictedPolicy
  def index?
    current_user.is_a?(Doctor) || current_user.is_a?(Patient) || current_user.is_a?(Admin)
  end

  def create?
    current_user.is_a? Patient
  end

  def new?
    create?
  end

  def show?
    current_user.is_a?(Admin) || current_user == @record.doctor || current_user == @record.patient
  end

  def confirm?
    show?
  end

  def cancel?
    show?
  end

  def destroy?
    current_user.is_a? Admin
  end

end
