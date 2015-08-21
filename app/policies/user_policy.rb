class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    @current_user.is_a? Admin
  end

  def show?
    @current_user.is_a? Admin or @current_user == @user
  end

  def update?
    @current_user.is_a? Admin
  end

  def destroy?
    return false if @current_user == @user
    @current_user.is_a? Admin
  end

end
