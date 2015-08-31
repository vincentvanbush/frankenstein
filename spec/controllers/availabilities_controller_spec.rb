require 'rails_helper'

RSpec.describe AvailabilitiesController, type: :controller do
  let(:doctor) { FactoryGirl.create :doctor }
  let(:clinic) { FactoryGirl.create :clinic }
  let(:admin) { FactoryGirl.create :admin }
  before { FactoryGirl.create :assignment,
                              doctor: doctor,
                              clinic: clinic }

  before { controller.stub(:current_user).and_return(admin) }

  describe "POST #create" do
    context "with valid parameters" do
      before { post :create, doctor_id: doctor.id,
                             availability: {
                               clinic_id: clinic.id,
                               day: 5, begin_time: '13:00', end_time: '14:00'
                             } }
      it_behaves_like 'a successful create request', Availability
    end

    context "with invalid parameters" do
      before { post :create, doctor_id: doctor.id, availability: {
                                  day: 10, begin_time: '19:00', end_time: '14:00'
                                } }
      it_behaves_like 'a failed create request', Availability
    end

  end

  describe "DELETE #destroy" do
    before do
      FactoryGirl.create :availability, doctor: doctor, clinic: clinic
      delete :destroy, doctor_id: doctor.id, id: Availability.first.id
    end
    it_behaves_like 'a successful delete request', Availability
  end

  describe "GET #new" do
    before { get :new, doctor_id: doctor.id }
    it_behaves_like 'a successful new request'
  end

end
