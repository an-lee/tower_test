class AddUserNameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, default: "no name"
  end
end
