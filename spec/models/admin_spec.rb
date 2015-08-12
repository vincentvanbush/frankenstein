require 'rails_helper'

RSpec.describe Admin, type: :model do
  it { should validate_absence_of :pesel }
  it { should validate_absence_of :pwz }
end
