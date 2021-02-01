class AddMonthApplyToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_modify, :boolean
    add_column :attendances, :month_status, :string
    add_column :attendances, :month_superior, :string
    add_column :attendances, :apply_month, :date
  end
end
