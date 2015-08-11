FactoryGirl.define do
  factory :user do
    confirmed_at Time.now
    name "Test User"
    email Faker::Internet.email
    password "please123"
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    pesel Random.rand(10**11).to_s
    address Faker::Address.street_address

    trait :admin do
      role 'admin'
    end

    trait :doctor do
      role 'doctor'
    end

  end
end
