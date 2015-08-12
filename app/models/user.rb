class User < ActiveRecord::Base
  self.inheritance_column = :role

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
end
