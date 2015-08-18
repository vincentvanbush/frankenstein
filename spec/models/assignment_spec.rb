require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it { should belong_to :doctor }
  it { should belong_to :clinic }

  it { should validate_presence_of :doctor }
  it { should validate_presence_of :clinic }

  context "when identical to another existing assignment" do
    # shoulda-matchers validates_uniqueness_of fails strangely...
    let(:assignment) { FactoryGirl.create :assignment }
    let(:second_assignment) { FactoryGirl.build :assignment,
                                doctor: assignment.doctor,
                                clinic: assignment.clinic }
    subject { second_assignment }
    it { should_not be_valid }
  end

end
