class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :clinic, index: true, foreign_key: true
      t.datetime :begins_at
      t.datetime :ends_at

      t.timestamps null: false
    end
  end
end
