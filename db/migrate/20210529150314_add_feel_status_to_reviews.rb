class AddFeelStatusToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :feel_status, :integer
  end
end
