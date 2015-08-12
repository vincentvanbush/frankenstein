FactoryGirl.define do
  factory :patient, class: Patient, parent: :user do
    role "Patient"
    pesel { Random.rand(10**10...10**11).to_s }
    pwz nil
  end

end
