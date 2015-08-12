class AddPwzToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pwz, :string
  end
end
