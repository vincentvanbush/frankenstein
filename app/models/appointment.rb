class Appointment < ActiveRecord::Base
  belongs_to :clinic
  belongs_to :doctor, class_name: "User"
  belongs_to :patient, class_name: "User"

  validates :clinic, presence: true
  validates :doctor, presence: true
  validates :patient, presence: true
  validates :begins_at, presence: true
  validates :ends_at, presence: true

  with_options if: :dates_present? do |a|
    a.validate :future_date
    a.validate :timeliness
    a.validate :same_day
    a.validate :matches_availability
    a.validate :no_overlapping_appointments
  end

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
    day_of_week = begins_at.wday
    matches = Availability.where(day: day_of_week, doctor: doctor)
      .select { |av| av.begin_time <= begins_at.to_time_of_day.to_s }
      .select { |av| av.end_time >= ends_at.to_time_of_day.to_s }
    # binding.pry
    errors.add(:base, 'does not match any availability') if matches.empty?
  end

  def no_overlapping_appointments
    # binding.pry
    matches = Appointment.where(doctor: doctor)
      .select { |ap| (ap.begins_at < begins_at && ap.ends_at > begins_at) ||
                     (ap.ends_at > begins_at && ap.begins_at < ends_at) }
      .select { |ap| ap != self }
    errors.add(:base, 'conflicts with an existing appointment') if matches.present?
  end

  def dates_present?
    begins_at.present? && ends_at.present?
  end

end
