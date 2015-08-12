class ChangeCancelledToCancelledAtInAppointments < ActiveRecord::Migration
  def change
    remove_column :appointments, :cancelled
    add_column :appointments, :cancelled_at, :datetime
  end
end
