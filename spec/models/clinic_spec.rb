require 'rails_helper'

RSpec.describe Clinic, type: :model do
  it { should have_many(:availabilities) }
  it { should have_many(:appointments) }
  it { should have_many(:doctors).through(:availabilities) }

  it { should validate_presence_of(:name) }
end
