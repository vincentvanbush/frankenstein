require 'rails_helper'

describe PatientPolicy do
  let (:patient) { FactoryGirl.build_stubbed :patient }
  let (:admin) { FactoryGirl.build_stubbed :admin }

  describe "strong parameters" do
    let(:expected_attrs) {
      [:email, :password, :first_name, :last_name, :pesel, :address]
    }

    context "for the same user" do
      let(:policy) { PatientPolicy.new(patient, patient) }
      it { expect(policy.permitted_attributes).to eql(expected_attrs) }
    end

    context "for admin" do
      let(:policy) { PatientPolicy.new(admin, patient) }
      it { expect(policy.permitted_attributes)
           .to eql(expected_attrs + [:approved] ) }
    end

  end

end
