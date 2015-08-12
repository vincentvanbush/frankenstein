class Patient < User
  has_many :appointments, foreign_key: "patient_id"

  validates :pesel, presence: true, format: { with: /\A[0-9]{11}\z/ }
  validates :pwz, absence: true

end
