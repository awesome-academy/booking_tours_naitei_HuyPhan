class AddTitleToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :title, :text
  end
end
