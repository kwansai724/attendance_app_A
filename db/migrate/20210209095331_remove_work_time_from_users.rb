class RemoveWorkTimeFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :work_time, :datetime, default: Time.current.change(hour: 7, min: 30, sec: 0)
  end
end
