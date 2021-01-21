class AddOvertimeApplyToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_at, :datetime
    add_column :attendances, :next_day, :boolean
    add_column :attendances, :work_content, :string
    add_column :attendances, :superior_confirmation, :string
  end
end
