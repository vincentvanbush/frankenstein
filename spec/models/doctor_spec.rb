require 'rails_helper'

RSpec.describe Doctor, type: :model do
  it { should have_many(:availabilities) }
  it { should have_many(:appointments) }
  it { should have_many(:assignments) }

  it { should respond_to(:pesel) }

  it { should validate_presence_of(:pwz) }
  it { should validate_absence_of(:pesel) }

  context "with invalid pwz" do
    let(:doctor) { FactoryGirl.build :doctor, pwz: "bullshyt" }
    subject { doctor }
    it { should_not be_valid }
  end

  context '#first_availability_date' do
    let!(:availability) { FactoryGirl.create :availability, day: 2,
                                             begin_time: "10:00",
                                             end_time: "11:00" }
    let!(:availability) { FactoryGirl.create :availability, day: 3,
                                             begin_time: "11:00",
                                             end_time: "12:00" }
    let!(:doctor) { availability.doctor }
    let(:appointment) { FactoryGirl.create :appointment,
                          doctor: availability.doctor,
                          clinic: availability.clinic,
                          begins_at: Chronic.parse("next Tuesday 10:00"),
                          ends_at: Chronic.parse("next Tuesday 11:00") }
    subject { doctor.first_availability_date(availability.clinic) }
    it { should eq(Chronic.parse("next Wednesday 00:00")) }
  end

end
