require 'rails_helper'

describe DoctorPolicy do
  let (:doctor) { FactoryGirl.build_stubbed :doctor }
  let (:admin) { FactoryGirl.build_stubbed :admin }

  describe "strong parameters" do
    let(:expected_attrs) {
      [:email, :password, :first_name, :last_name, :pwz]
    }

    context "for the same user" do
      let(:policy) { DoctorPolicy.new(doctor, doctor) }
      it { expect(policy.permitted_attributes).to eql(expected_attrs) }
    end

    context "for admin" do
      let(:policy) { DoctorPolicy.new(admin, doctor) }
      it { expect(policy.permitted_attributes)
           .to eql(expected_attrs + [:approved] ) }
    end

  end

end
