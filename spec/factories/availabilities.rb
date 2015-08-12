FactoryGirl.define do
  factory :availability do
    doctor { FactoryGirl.create :doctor }
    clinic
    day { Random.rand(7) + 1 }
    begin_time "10:00"
    end_time "14:00"
  end

end
