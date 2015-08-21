class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
    @user_attrs = [:email, :password, :first_name, :last_name]
  end

  def index?
    @current_user.is_a? Admin
  end

  def show?
    @current_user.is_a? Admin or @current_user == @user
  end

  def update?
    @current_user.is_a? Admin or @current_user == @user
  end

  def destroy?
    return false if @current_user == @user
    @current_user.is_a? Admin
  end

  def permitted_attributes
    if @current_user.is_a? Admin
      @user_attrs + [:approved]
    else
      @user_attrs
    end
  end

end
