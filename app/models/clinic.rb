class Clinic < ActiveRecord::Base
  has_many :availabilities
  has_many :appointments
  has_many :doctors, -> { distinct }, through: :availabilities
  has_many :assignments

  validates :name, presence: true
end
