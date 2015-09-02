require 'rails_helper'

RSpec.describe ClinicsController, type: :controller do
  let(:clinic) { FactoryGirl.create :clinic }
  let(:patient) { FactoryGirl.create :patient }
  let(:admin) { FactoryGirl.create :admin }

  describe "GET #index" do
    it_behaves_like "a successful index request"
  end

  describe "GET #show" do
    before { get :show, id: clinic.id }
    it_behaves_like "a successful show request"
  end

  describe "GET #new" do
    describe "when not logged in" do
      before { get :new }
      it_behaves_like "an unauthorized request"
    end

    describe "when logged in as admin" do
      before { stub_current_user(admin)
               get :new }
      it_behaves_like "a successful new request"
    end
  end

  describe "GET #edit" do
    describe "when not logged in" do
      before { get :edit, id: clinic.id }
      it_behaves_like "an unauthorized request"
    end

    describe "when logged in as admin" do
      before { stub_current_user(admin)
               get :edit, id: clinic.id }
      it_behaves_like "a successful edit request"
    end
  end

  describe "POST #create" do
    describe "when not logged in" do
      before { post :create, clinic: { name: 'Psychiatryk' } }
      it_behaves_like "an unauthorized request"
    end

    describe "when logged in as admin" do
      before { stub_current_user(admin)
               post :create, clinic: { name: 'Psychiatryk' } }
      it_behaves_like "a successful create request", Clinic
    end

  end

  describe "PATCH #update" do
    describe "when not logged in" do
      before { patch :update, id: clinic.id, clinic: { name: 'Odwyk' } }
      it_behaves_like "an unauthorized request"
    end

    describe "when logged in as admin" do
      before { stub_current_user(admin)
               patch :update, id: clinic.id, clinic: { name: 'Odwyk' } }
      it { expect(Clinic.first.name).to eq('Odwyk') }
    end

  end

  describe "DELETE #destroy" do
    describe "when not logged in" do
      before { delete :destroy, id: clinic.id }
      it_behaves_like "an unauthorized request"
    end

    describe "when logged in as admin" do
      before { stub_current_user(admin)
               delete :destroy, id: clinic.id }
      it_behaves_like "a successful delete request", Clinic
    end

  end

end
