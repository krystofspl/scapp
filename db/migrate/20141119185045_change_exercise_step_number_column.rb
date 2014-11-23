class ChangeExerciseStepNumberColumn < ActiveRecord::Migration
  def up
    rename_column :exercise_steps, :step_number, :row_order
  end
  def down
    rename_column :exercise_steps, :row_order,:step_number
  end
end
