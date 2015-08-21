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

  context "unapproved" do
    let(:user) { FactoryGirl.create :user, approved: false }
    subject { :user }
    it { expect(user).not_to be_active_for_authentication }
  end

  context "approved" do
    let(:user) { FactoryGirl.create :user, approved: true }
    subject { :user }
    it { expect(user).to be_active_for_authentication }
  end

end
