class AddBasicNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :user_number, :integer
    add_column :users, :card_id, :integer
  end
end
