class AddConfirmToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :confirm_token, :string
    add_column :users, :confirmed_at, :datetime
  end
end
