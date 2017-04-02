class AddTodoIdToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :todo_id, :integer
  end
end
