class FullyRestrictedPolicy
  attr_reader :current_user, :model

  def initialize(current_user, record)
    @current_user = current_user
    @record = record
  end

  def create?
    @current_user.is_a? Admin
  end

  def destroy?
    @current_user.is_a? Admin
  end

  def new?
    @current_user.is_a? Admin
  end

  def show?
    @current_user.is_a? Admin
  end

  def index?
    @current_user.is_a? Admin
  end

  def update?
    @current_user.is_a? Admin
  end

end
