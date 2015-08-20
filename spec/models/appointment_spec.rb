require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it { should belong_to(:clinic) }
  it { should belong_to(:doctor) }
  it { should belong_to(:patient) }
  it { should belong_to(:availability) }
  it { should validate_presence_of(:clinic) }
  it { should validate_presence_of(:doctor) }
  it { should validate_presence_of(:patient) }
  it { should validate_presence_of(:availability) }

  let!(:time_now) { Time.zone.parse("12 Dec 2015 15:00 +0100") }
  before { Time.stub(:current).and_return(time_now) }

  let(:availability) { FactoryGirl.create :availability,
                                          day: 1,
                                          begin_time: "12:30",
                                          end_time: "14:30" }

  let(:appointment) { FactoryGirl.build :appointment,
                                        doctor: availability.doctor,
                                        clinic: availability.clinic,
                                        begins_at: "14 Dec 2015 13:00 +0100",
                                        ends_at: "14 Dec 2015 13:30 +0100",
                                        availability: availability }

  subject { appointment }

  context "created with past date" do
    before { appointment.begins_at = "7 Dec 2015 13:00 +0100"
             appointment.ends_at = "7 Dec 2015 13:30 +0100" }
    it { should_not be_valid }
  end

  context "created with end date before start date" do
    before { appointment.begins_at = "14 Dec 2015 14:00 +0100"
             appointment.ends_at = "14 Dec 2015 13:30 +0100" }
    it { should_not be_valid }
  end

  context "created so that it matches an availability" do

    context "without overlapping any other appointment" do
      it { should be_valid }
    end

    context "but overlaps another appointment of the same doctor in the same clinic" do
      before { appointment.save }
      let(:invalid_appointment) { FactoryGirl.build :appointment,
                                    doctor: appointment.doctor,
                                    clinic: appointment.clinic,
                                    begins_at: "14 Dec 2015 13:15 +0100",
                                    ends_at: "14 Dec 2015 13:45 +0100" }
      subject { invalid_appointment }
      it { should_not be_valid }
    end

  end

  context "created so that it does not match its availability" do
    context "because of another doctor" do
      before { appointment.doctor = FactoryGirl.create :doctor }
      it { should_not be_valid }
    end

    context "because of another date" do
      before { appointment.begins_at = "16 Dec 2015 20:00 +0100"
               appointment.ends_at = "16 Dec 2015 20:30 +0100" }
      it { should_not be_valid }
    end

    context "because of another clinic" do
      before { appointment.clinic = FactoryGirl.create :clinic }
      it { should_not be_valid }
    end

    context "because it is not its parent availability" do
      before { appointment.availability = FactoryGirl.create :availability,
                                            day: 4,
                                            begin_time: "17:30",
                                            end_time: "18:30" }
      it { should_not be_valid }
    end

  end

  context "confirmation" do
    context "within the first 10 minutes since creation" do
      before { appointment.created_at = Time.current
               appointment.confirmed_at = Time.zone.parse("12 Dec 2015 15:05 +0100") }
      it { should be_valid }
    end

    context "later than 10 minutes since creation" do
      before { appointment.created_at = Time.current
               appointment.confirmed_at = Time.zone.parse("12 Dec 2015 15:15 +0100") }
      it { should_not be_valid }
    end

  end

  context "cancellation" do
    context "if it's a future appointment" do
      before { appointment.cancelled_at = "14 Dec 2015 12:59 +0100" }
      it { should be_valid }
    end

    context "if it has already begun" do
      before { appointment.cancelled_at = "14 Dec 2015 13:00:30 +0100" }
      it { should_not be_valid }
    end

  end

end
