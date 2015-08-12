require 'rails_helper'

RSpec.describe Availability, type: :model do
  it { should belong_to(:doctor) }
  it { should belong_to(:clinic) }
  it { should validate_presence_of(:doctor) }
  it { should validate_presence_of(:clinic) }
  it { should validate_numericality_of(:day)
                .only_integer.is_greater_than_or_equal_to(0)
                .is_less_than_or_equal_to(6) }

  context "created with end time earlier than start time" do
    subject { FactoryGirl.build :availability,
              begin_time: '10:00',
              end_time: '9:00' }
    it { should_not be_valid }
  end

end
