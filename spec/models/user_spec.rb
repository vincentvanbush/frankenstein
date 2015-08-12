describe User do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:address) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:address) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

end
