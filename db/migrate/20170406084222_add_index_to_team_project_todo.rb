class AddIndexToTeamProjectTodo < ActiveRecord::Migration[5.0]
  def change
    add_index :teams, :user_id
    add_index :projects, :user_id
    add_index :projects, :team_id
    add_index :todos, :user_id
    add_index :todos, :project_id
    add_index :messages, :project_id
  end
end
