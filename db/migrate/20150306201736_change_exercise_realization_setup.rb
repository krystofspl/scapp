class ChangeExerciseRealizationSetup < ActiveRecord::Migration
  def change
    change_table :exercise_realization_setups do |t|
      t.references :exercise_realization, index: true
      t.float :numeric_value
      t.string :string_value
      t.text :note

      t.timestamps
    end
  end
end
