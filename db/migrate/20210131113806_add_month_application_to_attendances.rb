class AddMonthApplicationToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_modify, :boolean
    add_column :attendances, :month_status, :string
  end
end
