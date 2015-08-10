class AddDoctorAndPatientIdsToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :doctor_id, :integer, index: true
    add_column :appointments, :patient_id, :integer, index: true

    add_foreign_key :appointments, :users, column: :doctor_id, on_delete: :cascade
    add_foreign_key :appointments, :users, column: :patient_id, on_delete: :cascade
  end
end
