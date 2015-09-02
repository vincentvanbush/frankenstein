class AvailabilityPolicy < FullyRestrictedPolicy
  def new?
    current_user.is_a?(Doctor) || current_user.is_a?(Admin)
  end

  def create?
    current_user == @record.doctor || current_user.is_a?(Admin)
  end

  def destroy?
    create?
  end
end
