class CreateExerciseSteps < ActiveRecord::Migration
  def change
    create_table :exercise_steps do |t|
      t.string :name, null: false
      t.string :description
      t.integer :step_number, null: false, default: 1
      t.references :exercise, index: true

      t.timestamps
    end
  end
end
