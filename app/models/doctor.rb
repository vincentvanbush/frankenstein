class Doctor < User
  has_many :appointments, foreign_key: "doctor_id"
  has_many :availabilities, foreign_key: "doctor_id"
  has_many :assignments, foreign_key: "doctor_id"

  validates :pwz, presence: true, format: { with: /\A[0-9]{7}\z/ }
  validates :pesel, absence: true

  def first_availability_date(clinic)
    connection = ActiveRecord::Base.connection.raw_connection
    st = connection.exec("select first_availability_date($1, $2)", [ id, clinic.id ])
    Chronic.parse(st[0]["first_availability_date"])
  end

end
