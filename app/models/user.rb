class User < ActiveRecord::Base
  has_many :availabilities, foreign_key: "doctor_id"

  enum role: [:user, :doctor, :admin]
  after_initialize :set_default_role, :if => :new_record?

  with_options unless: :doctor? do |u|
    u.validates :pesel, presence: true, format: { with: /\A[0-9]{11}\z/ }
    u.validates :pwz, absence: true
  end

  with_options if: :doctor? do |u|
    u.validates :pwz, presence: true, format: { with: /\A[0-9]{7}\z/ }
    u.validates :pesel, absence: true
  end

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
end
