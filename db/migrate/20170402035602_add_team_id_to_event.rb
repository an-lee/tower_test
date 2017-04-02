class AddTeamIdToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :team_id, :integer
  end
end
