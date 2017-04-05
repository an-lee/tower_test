class AddIsTrashToTodo < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :is_trash, :boolean, default: false
  end
end
