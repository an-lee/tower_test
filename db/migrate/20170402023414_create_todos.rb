class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.text :description
      t.date :due
      t.string :assign
      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end
  end
end
