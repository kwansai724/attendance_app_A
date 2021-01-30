class AddChangeApplicationToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :tomorrow, :boolean
    add_column :attendances, :superior_check, :string
    add_column :attendances, :modify, :boolean
    add_column :attendances, :change_status, :string
  end
end
