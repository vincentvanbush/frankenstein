FactoryGirl.define do
  factory :appointment do
    doctor
    patient
    clinic
    begins_at "2015-08-11 17:30:00"
    ends_at "2015-08-11 18:00:00"
  end

end
