class ChangeDataTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :started_at, :time
    change_column :attendances, :finished_at, :time
  end
end
