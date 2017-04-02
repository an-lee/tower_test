class AddProjectIdToTodo < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :project_id, :integer
  end
end
