class Availability < ActiveRecord::Base
  belongs_to :doctor, class_name: "User"
  belongs_to :clinic
end
