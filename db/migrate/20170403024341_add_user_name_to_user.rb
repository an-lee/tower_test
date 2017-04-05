class AddUserNameToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, default: "Anonym"
  end
end
