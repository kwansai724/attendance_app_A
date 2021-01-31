class AddMonthApplicationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :month_modify, :boolean
    add_column :users, :month_status, :string
    add_column :users, :month_superior, :string
  end
end
