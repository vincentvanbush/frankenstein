FactoryGirl.define do
  factory :appointment do
    transient do
      begin_time { Faker::Time.between(Time.now, 1.month.from_now, :all) }
    end

    doctor { FactoryGirl.create :user, :doctor }
    patient { FactoryGirl.create :user }
    clinic
    begins_at { begin_time.to_s }
    ends_at { begin_time.to_s }
  end

end
