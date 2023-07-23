class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.references :project, null: false, foreign_key: true
      t.text :description
      t.datetime :startTime
      t.datetime :endTime
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
