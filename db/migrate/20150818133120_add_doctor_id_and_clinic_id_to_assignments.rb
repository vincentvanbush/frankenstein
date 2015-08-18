class AddDoctorIdAndClinicIdToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :doctor_id, :integer, index: true
    add_column :assignments, :clinic_id, :integer, index: true
    
    add_foreign_key :assignments, :users, column: :doctor_id, on_delete: :cascade
    add_foreign_key :assignments, :clinics, column: :clinic_id, on_delete: :cascade
  end
end
