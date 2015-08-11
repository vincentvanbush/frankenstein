class AddDoctorAndClinicForeignKeysToAvailabilities < ActiveRecord::Migration
  def change
    add_foreign_key :availabilities, :users, column: :doctor_id, on_delete: :cascade
    add_foreign_key :availabilities, :clinics, on_delete: :cascade
  end
end
