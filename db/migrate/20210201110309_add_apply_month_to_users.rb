class AddApplyMonthToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :apply_month, :date
  end
end
