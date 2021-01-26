class AddOvertimeApplyToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :application, :string
    add_column :attendances, :change, :boolean
  end
end
