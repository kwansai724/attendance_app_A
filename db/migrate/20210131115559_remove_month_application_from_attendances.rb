class RemoveMonthApplicationFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :month_modify, :boolean
    remove_column :attendances, :month_status, :string
  end
end
