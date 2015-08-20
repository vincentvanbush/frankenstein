class Appointment < ActiveRecord::Base
  belongs_to :clinic
  belongs_to :doctor
  belongs_to :patient
  belongs_to :availability

  validates :clinic, presence: true
  validates :doctor, presence: true
  validates :patient, presence: true
  validates :begins_at, presence: true
  validates :ends_at, presence: true
  validates :availability, presence: true

  with_options if: :dates_present? do |a|
    a.validate :future_date
    a.validate :timeliness
    a.validate :same_day
    a.validate :matches_availability
    a.validate :no_overlapping_appointments
  end

  validate :confirmed_in_ten_minutes
  validate :cancelled_before_begin

  def future_date
    errors.add(:begins_at, 'must be a future date') unless begins_at > Time.current
    errors.add(:ends_at, 'must be a future date') unless ends_at > Time.current
  end

  def timeliness
    errors.add(:ends_at, 'must be after begin time') unless ends_at > begins_at
  end

  def same_day
    unless ends_at.beginning_of_day == begins_at.beginning_of_day
      errors.add(:ends_at, 'must be on the same day as begin date')
    end
  end

  def matches_availability
    return unless availability.present?

    failure ||= doctor != availability.doctor
    failure ||= clinic != availability.clinic

    day_of_week = begins_at.wday
    failure ||= day_of_week != availability.day

    availability_begin = Tod::TimeOfDay.parse(availability.begin_time)
    availability_end = Tod::TimeOfDay.parse(availability.end_time)
    failure ||= availability_begin > begins_at.to_time_of_day
    failure ||= availability_end < ends_at.to_time_of_day

    errors.add(:base, 'does not match the specified availability') if failure
  end

  def no_overlapping_appointments
    matches = availability.appointments.where(doctor: doctor)
      .select { |ap| (ap.begins_at < begins_at && ap.ends_at > begins_at) ||
                     (ap.ends_at > begins_at && ap.begins_at < ends_at) }
      .select { |ap| ap != self }
    errors.add(:base, 'conflicts with an existing appointment') if matches.present?
  end

  def dates_present?
    begins_at.present? && ends_at.present?
  end

  def confirmed_in_ten_minutes
    if confirmed_at.present? && created_at.present?
      errors.add(:base, 'must be confirmed within 10 minutes') if confirmed_at - created_at > 10.minutes
    end
  end

  def cancelled_before_begin
    if cancelled_at.present? && cancelled_at > begins_at
      errors.add(:base, 'cannot be cancelled after begin of appointment')
    end
  end

end
