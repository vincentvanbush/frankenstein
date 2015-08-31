module UserHelpers
  def stub_current_user(user)
    controller.stub(:current_user).and_return(user)
  end
end

RSpec.configure do |c|
  c.include UserHelpers
end
