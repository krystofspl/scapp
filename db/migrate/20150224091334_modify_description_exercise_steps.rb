class ModifyDescriptionExerciseSteps < ActiveRecord::Migration
  def up
    change_column :exercise_steps, :description, :text
  end

  def down
    change_column :exercise_steps, :description, :string
  end
end
