class Availability < ActiveRecord::Base
  belongs_to :doctor
  belongs_to :clinic

  validates :doctor, presence: true
  validates :clinic, presence: true
  validates :day, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 6
  }
  validates :begin_time, presence: true
  validates :end_time, presence: true

  validate :timeliness

  def timeliness
    begin_tod = Tod::TimeOfDay.try_parse(begin_time)
    end_tod = Tod::TimeOfDay.try_parse(end_time)
    unless begin_tod.nil? || end_tod.nil?
      errors.add(:end_time, 'must be after start time') if end_tod <= begin_tod
    end
  end

  validate :corresponding_assignment

  def corresponding_assignment
    matches = Assignment.where(doctor: doctor, clinic: clinic)
    errors.add(:base, 'does not match any doctor-clinic assignment') if matches.empty?
  end

end
