require 'rails_helper'

RSpec.describe Patient, type: :model do
  it { should have_many(:appointments) }

  it { should respond_to(:pwz) }

  it { should validate_presence_of(:pesel) }
  it { should validate_absence_of(:pwz) }

  context "with invalid pesel" do
    let(:patient) { FactoryGirl.build :patient, pesel: "bullshyt" }
    subject { patient }
    it { should_not be_valid }
  end

end
