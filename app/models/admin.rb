class Admin < User
  validates_absence_of :pwz
  validates_absence_of :pesel
end
