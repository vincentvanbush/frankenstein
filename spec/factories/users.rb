FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email}
    password "please123"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address { Faker::Address.street_address }
  end
end
