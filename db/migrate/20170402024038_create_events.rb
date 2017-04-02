class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :action
      t.string :title
      t.text :content
      t.integer :user_id
      t.timestamps
    end
  end
end
