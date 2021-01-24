class AddApprovalInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :application, :string
    add_column :users, :change, :boolean
  end
end
