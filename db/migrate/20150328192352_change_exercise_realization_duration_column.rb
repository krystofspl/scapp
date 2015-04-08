class ChangeExerciseRealizationDurationColumn < ActiveRecord::Migration
  def up
    change_column :exercise_realizations, :time_duration, :integer, null: true, default: 300
  end
  def down
    change_column :exercise_realizations, :time_duration, :integer, null: false, default: 300
  end
end
