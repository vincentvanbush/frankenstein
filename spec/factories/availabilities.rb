FactoryGirl.define do
  factory :availability do
    transient do
      assignment { FactoryGirl.create :assignment }
    end

    doctor { assignment.doctor }
    clinic { assignment.clinic }
    day { Random.rand(0..6) }
    begin_time "10:00"
    end_time "14:00"
  end

end
