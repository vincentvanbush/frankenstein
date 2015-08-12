describe User do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it { should respond_to(:pesel) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:address) }

  context "for a non-doctor" do
    it { should validate_presence_of(:pesel) }
    it { should validate_absence_of(:pwz) }
  end

  context "for a doctor" do
    before { @user.role = "doctor" }
    it { should validate_presence_of(:pwz) }
    it { should validate_absence_of(:pesel) }
  end

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:address) }

  it { should have_many(:availabilities) }

  it "should give error for invalid pesel" do
    @user.pesel = "bullshit"
    expect(@user).not_to be_valid
  end

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

end
