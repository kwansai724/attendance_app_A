class ChangeDataTimesToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :started_at, :datetime
    change_column :attendances, :finished_at, :datetime
  end
end
