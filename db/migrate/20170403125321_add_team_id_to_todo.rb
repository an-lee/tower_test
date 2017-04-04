class AddTeamIdToTodo < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :team_id, :integer
  end
end
