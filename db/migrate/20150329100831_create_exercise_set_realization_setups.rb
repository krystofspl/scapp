class CreateExerciseSetRealizationSetups < ActiveRecord::Migration
  def change
    create_table :exercise_set_realization_setups do |t|
      t.references :exercise_set_realization
      t.string :exercise_setup_code
      t.float :numeric_value
      t.string :string_value
      t.text :note

      t.timestamps
    end
  end
end
