class Doctor < User
  has_many :appointments, foreign_key: "doctor_id"
  has_many :availabilities, foreign_key: "doctor_id"
  has_many :assignments, foreign_key: "doctor_id"

  validates :pwz, presence: true, format: { with: /\A[0-9]{7}\z/ }
  validates :pesel, absence: true

  def first_availability_date(clinic)
    first_available_after(Chronic.parse("today"), clinic)
  end

  def first_available_after(datetime, clinic)
    clinic_availabilities = availabilities.where(clinic: clinic)
    day_to_check = clinic_availabilities
                   .map { |av| Date::DAYNAMES[av.day] }
                   .map { |day| Chronic.parse('00:00 next ' + day, now: datetime) }
                   .uniq.min
    weekday = day_to_check.wday
    availability_sum = clinic_availabilities.where(day: weekday)
                       .sum("end_time::interval - begin_time::interval")
    appointment_sum = appointments.where("begins_at >= ? and ends_at < ?",
                                         day_to_check, day_to_check + 1.day)
                      .sum("ends_at::time - begins_at::time")

    if Tod::TimeOfDay.parse(appointment_sum) == Tod::TimeOfDay.parse(availability_sum)
      return first_available_after day_to_check, clinic
    else
      return day_to_check
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end
