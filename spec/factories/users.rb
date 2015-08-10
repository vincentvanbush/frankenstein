FactoryGirl.define do
  factory :user do
    confirmed_at Time.now
    name "Test User"
    email "test@example.com"
    password "please123"
    first_name "Aston"
    last_name "Marcin"
    pesel "93031012345"
    address "Ćwiartki 3/4, Wrocław"

    trait :admin do
      role 'admin'
    end

  end
end
