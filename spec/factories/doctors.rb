FactoryGirl.define do
  factory :doctor, class: Doctor, parent: :user do
    role "Doctor"
    pesel nil
    pwz { Random.rand(10**6...10**7).to_s }
  end

end
