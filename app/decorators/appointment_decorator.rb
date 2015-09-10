class AppointmentDecorator < Draper::Decorator
  delegate_all

  def can_be_confirmed?
    return false if object.expired?
    return false if object.cancelled?
    true
  end

  def can_be_cancelled?
    return false if Time.current > object.begins_at
    unless object.confirmed?
      return false if object.expired?
    end
    return false if object.cancelled?
    true
  end

  def doctor_caption
    "#{object.doctor.first_name} #{object.doctor.last_name}"
  end

  def patient_caption
    "#{object.patient.first_name} #{object.patient.last_name}"
  end

  def minutes_to_confirm
    10 - (Time.current - object.created_at).to_i / 60
  end

  def duration
    (object.ends_at - object.begins_at) / 60
  end

end
