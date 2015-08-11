FactoryGirl.define do
  factory :availability do
    doctor { FactoryGirl.create :user, :doctor }
    clinic
    day { Random.rand(7) + 1 }
    begin_time "MyString"
    end_time "MyString"
  end

end
