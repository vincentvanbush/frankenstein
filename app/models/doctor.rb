class Doctor < User
  has_many :appointments, foreign_key: "doctor_id"
  has_many :availabilities, foreign_key: "doctor_id"
  has_many :assignments, foreign_key: "doctor_id"

  validates :pwz, presence: true, format: { with: /\A[0-9]{7}\z/ }
  validates :pesel, absence: true

end
