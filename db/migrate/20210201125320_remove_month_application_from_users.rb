class RemoveMonthApplicationFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :month_modify, :boolean
    remove_column :users, :month_status, :string
    remove_column :users, :month_superior, :string
    remove_column :users, :apply_month, :date
  end
end
