require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  let(:doctor) { FactoryGirl.create :doctor }
  let(:clinic) { FactoryGirl.create :clinic }
  let(:patient) { FactoryGirl.create :patient }
  let(:admin) { FactoryGirl.create :admin }
  let(:assignment) { FactoryGirl.create :assignment,
                                        doctor: doctor, clinic: clinic }
  let(:availability) { FactoryGirl.create :availability,
                                          assignment: assignment,
                                          doctor: doctor, clinic: clinic,
                                          day: 5, begin_time: "10:00",
                                          end_time: "15:00" }

  describe "GET #index" do
    context "when logged in as a patient" do
      before { stub_current_user(patient) }
      it_behaves_like 'a successful index request'
    end

    context "when logged in as a doctor" do
      before { stub_current_user(doctor) }
      it_behaves_like 'a successful index request'
    end

    context "when logged in as an admin" do
      before { stub_current_user(admin) }
      it_behaves_like 'a successful index request'
    end

    context "when not logged in" do
      it_behaves_like 'an unauthorized index request'
    end
  end

  context "POST #create" do
    let(:appointment_params) { { assignment_id: assignment.id,
                                 availability_id: availability.id,
                                 doctor_id: doctor.id,
                                 clinic_id: clinic.id,
                                 patient_id: patient.id,
                                 begins_at: Chronic.parse('next Friday 12:00'),
                                 ends_at: Chronic.parse('next Friday 13:00') } }

    context "when logged in as a patient" do
      before { stub_current_user(patient)
               post :create, appointment: appointment_params }
      it_behaves_like 'a successful create request', Appointment
      it { expect(response).to redirect_to(appointment_path(Appointment.last)) }
    end

    context "when logged in as a doctor" do
      before { stub_current_user(doctor)
               post :create, appointment: appointment_params }
      it_behaves_like 'a failed create request', Appointment
    end

    context "when logged in as an admin" do
      before { stub_current_user(admin)
               post :create, appointment: appointment_params }
      it_behaves_like 'a failed create request', Appointment
    end

    context "when not logged in" do
      before { post :create, appointment: appointment_params }
      it_behaves_like 'a failed create request', Appointment
    end

  end

  context "PATCH" do
    before { FactoryGirl.create :appointment,
                                availability: availability,
                                doctor: doctor,
                                clinic: clinic,
                                patient: patient,
                                begins_at: Chronic.parse('next Friday 12:00'),
                                ends_at: Chronic.parse('next Friday 13:00') }
    let(:appointment) { Appointment.first }

    shared_context "a successful request" do |action, trait|
      before { patch action.to_sym, id: appointment.id }
      it { expect(response).to redirect_to appointment_path(appointment) }
      it { expect(Appointment.first).to send("be_" + trait) }
    end

    shared_context "a failed request" do |action, trait|
      before { patch action, id: appointment.id }
      it { expect(response).not_to redirect_to appointment_path(appointment) }
      it { expect(Appointment.first).not_to send("be_" + trait) }
    end

    context "#confirm" do
      shared_context "fails if more than 10 minutes after creation" do
        before { Time.stub(:current).and_return(appointment.created_at + 30.minutes) }
        it_behaves_like "a failed request", :confirm, "confirmed"
      end

      context "when logged in as the patient" do
        before { stub_current_user(patient) }
        it_behaves_like "a successful request", :confirm, "confirmed"
        it_behaves_like "fails if more than 10 minutes after creation"
      end

      context "when logged in as admin" do
        before { stub_current_user(admin) }
        it_behaves_like "a successful request", :confirm, "confirmed"
        it_behaves_like "fails if more than 10 minutes after creation"
      end

      context "when logged in as the doctor" do
        before { stub_current_user(doctor) }
        it_behaves_like "a successful request", :confirm, "confirmed"
        it_behaves_like "fails if more than 10 minutes after creation"
      end

      context "when not logged in" do
        before { patch :confirm, id: appointment.id }
        it_behaves_like "a failed request", :confirm, "confirmed"
      end
    end

    context "#cancel" do
      shared_context "fails if appointment has started" do
        before { Time.stub(:current).and_return(appointment.begins_at + 30.minutes) }
        it_behaves_like "a failed request", :cancel, "cancelled"
      end

      context "when logged in as the patient" do
        before { stub_current_user(patient) }
        it_behaves_like "a successful request", :cancel, "cancelled"
        it_behaves_like "fails if appointment has started"
      end

      context "when logged in as admin" do
        before { stub_current_user(admin) }
        it_behaves_like "a successful request", :cancel, "cancelled"
        it_behaves_like "fails if appointment has started"
      end

      context "when logged in as the doctor" do
        before { stub_current_user(doctor) }
        it_behaves_like "a successful request", :cancel, "cancelled"
        it_behaves_like "fails if appointment has started"
      end

      context "when not logged in" do
        before { patch :confirm, id: appointment.id }
        it_behaves_like "a failed request", :cancel, "cancelled"
      end

    end

  end

  describe "DELETE #destroy" do
    let(:appointment) { FactoryGirl.create :appointment,
                          availability: availability,
                          doctor: doctor,
                          clinic: clinic,
                          patient: patient,
                          begins_at: Chronic.parse('next Friday 12:00'),
                          ends_at: Chronic.parse('next Friday 13:00') }

    shared_context "a successful request" do
      before { delete :destroy, id: appointment.id }
      it { expect(response).to redirect_to appointments_path }
      it { expect(Appointment.count).to eq(0) }
    end

    shared_context "a failed request" do
      before { delete :destroy, id: appointment.id }
      it { expect(response).not_to redirect_to appointments_path }
      it { expect(Appointment.count).not_to eq(0) }
    end

    context "when logged in as admin" do
      before { stub_current_user(admin) }
      it_behaves_like "a successful request"
    end

    context "when logged in as patient" do
      before { stub_current_user(patient) }
      it_behaves_like "a failed request"
    end

    context "when logged in as doctor" do
      before { stub_current_user(doctor) }
      it_behaves_like "a failed request"
    end

    context "when not logged in" do
      it_behaves_like "a failed request"
    end

  end

end
