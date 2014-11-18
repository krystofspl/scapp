class CreateExerciseRealizations < ActiveRecord::Migration
  def change
    create_table :exercise_realizations do |t|
      t.string :exercise_code, index: true
      t.integer :exercise_version, index: true
    end
  end
end
