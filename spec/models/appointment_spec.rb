require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it { should belong_to :clinic }
  it { should belong_to :doctor }
  it { should belong_to :patient }
  it { should validate_presence_of(:clinic) }
  it { should validate_presence_of(:doctor) }
  it { should validate_presence_of(:patient) }

  let!(:time_now) { Time.zone.parse("12 Dec 2015 15:00 +0100") }
  before { Time.stub(:current).and_return(time_now) }

  let(:availability) { FactoryGirl.create :availability,
                                          day: 1,
                                          begin_time: "12:30",
                                          end_time: "14:30" }

  context "created with past date" do
    subject { FactoryGirl.build :appointment,
                                doctor: availability.doctor,
                                begins_at: "7 Dec 2015 13:00 +0100",
                                ends_at: "7 Dec 2015 13:30 +0100" }
    it { should_not be_valid }
  end

  context "created with end date before start date" do
    subject { FactoryGirl.build :appointment,
                                doctor: availability.doctor,
                                begins_at: "7 Dec 2015 14:00 +0100",
                                ends_at: "7 Dec 2015 13:30 +0100" }
    it { should_not be_valid }
  end

  context "created so that it matches an availability" do
    let(:valid_appointment) { FactoryGirl.build :appointment,
                                doctor: availability.doctor,
                                begins_at: "14 Dec 2015 13:00 +0100",
                                ends_at: "14 Dec 2015 13:30 +0100" }

    context "without overlapping any other appointment" do
      subject { valid_appointment }
      it { should be_valid }
    end

    context "but overlaps another appointment of the same doctor" do
      before { valid_appointment.save }
      let(:invalid_appointment) { FactoryGirl.build :appointment,
                                    doctor: valid_appointment.doctor,
                                    begins_at: "14 Dec 2015 13:15 +0100",
                                    ends_at: "14 Dec 2015 13:45 +0100" }
      subject { invalid_appointment }
      it { should_not be_valid }
    end

  end

  context "created so that it does not match any availability" do
    subject { FactoryGirl.build :appointment,
                                begins_at: "16 Dec 2015 20:00 +0100",
                                ends_at: "16 Dec 2015 20:30 +0100" }
    it { should_not be_valid }
  end

end
