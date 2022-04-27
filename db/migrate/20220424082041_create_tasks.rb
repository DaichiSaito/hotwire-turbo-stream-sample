class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.boolean :completed, null:false, default: false

      t.timestamps
    end
  end
end
