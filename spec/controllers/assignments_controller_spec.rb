require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  let(:doctor) { FactoryGirl.create :doctor }
  let(:clinic) { FactoryGirl.create :clinic }
  let(:admin) { FactoryGirl.create :admin }

  before { controller.stub(:current_user).and_return(admin) }

  describe "POST #create" do
    context "with valid parameters" do
      before { post :create, doctor_id: doctor.id, clinic_id: clinic.id }
      it("should create a record") { expect(Assignment.count).to eq(1) }
      it("should have a flash notice" ) { expect(flash[:notice]).to be_present }
    end

    context "with invalid parameters" do
      before { post :create, doctor_id: doctor.id, clinic_id: 67890 }
      it("should not create a record") { expect(Assignment.count).to eq(0) }
    end

  end

  describe "DELETE #destroy" do
    before { FactoryGirl.create :assignment, doctor: doctor, clinic: clinic }
    it "should destroy the record" do
      expect {
        delete :destroy, doctor_id: doctor.id, id: Assignment.first.id
      }.to change(Assignment, :count).from(1).to(0)
    end
  end

  describe "GET #new" do
    context "for an existing doctor" do
      before { get :new, doctor_id: doctor.id }

      it "should render the new assignment template" do
        expect(response).to render_template(:new)
      end

      it "should be ok" do
        expect(response).to have_http_status(:ok)
      end
    end

  end

end
