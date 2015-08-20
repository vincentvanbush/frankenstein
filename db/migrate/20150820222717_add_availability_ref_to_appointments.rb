class AddAvailabilityRefToAppointments < ActiveRecord::Migration
  def change
    add_reference :appointments, :availability, index: true, foreign_key: true
  end
end
