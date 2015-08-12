class ChangeConfirmedToConfirmedAtInAppointments < ActiveRecord::Migration
  def change
    remove_column :appointments, :confirmed
    add_column :appointments, :confirmed_at, :datetime
  end
end
