class Clinic < ActiveRecord::Base
  has_many :availabilities
  has_many :appointments
  has_many :doctors, -> { distinct }, through: :availabilities

  validates :name, presence: true
end
