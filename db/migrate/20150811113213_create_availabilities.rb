class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.integer :doctor_id
      t.integer :clinic_id
      t.integer :day
      t.string :begin_time
      t.string :end_time

      t.timestamps null: false
    end
  end
end
