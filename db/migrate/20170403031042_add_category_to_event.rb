class AddCategoryToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :category, :integer, default: "0"
  end
end
