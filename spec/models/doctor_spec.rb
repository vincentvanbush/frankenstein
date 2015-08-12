require 'rails_helper'

RSpec.describe Doctor, type: :model do
  it { should have_many(:availabilities) }
  it { should have_many(:appointments) }

  it { should respond_to(:pesel) }

  it { should validate_presence_of(:pwz) }
  it { should validate_absence_of(:pesel) }

  context "with invalid pwz" do
    let(:doctor) { FactoryGirl.build :doctor, pwz: "bullshyt" }
    subject { doctor }
    it { should_not be_valid }
  end

end
