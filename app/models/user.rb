class User < ActiveRecord::Base
  enum role: [:user, :doctor, :admin]
  after_initialize :set_default_role, :if => :new_record?

  validates :pesel, presence: true, format: {
    with: /\A[0-9]{11}\z/,
    message: I18n.t('activerecord.errors.models.user.attributes.pesel.invalid')
  }
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
