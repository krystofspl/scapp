class CreateExerciseBundleExercises < ActiveRecord::Migration
  def change
    create_table :exercise_bundle_exercises do |t|
      t.string :exercise_code, null: false
      t.string :exercise_bundle_code, null: false
      t.integer :exercise_version, null: false

      t.timestamps
    end
  end
  add_index :exercise_bundle_exercises, :exercise_code
  add_index :exercise_bundle_exercises, :exercise_set_code
end
