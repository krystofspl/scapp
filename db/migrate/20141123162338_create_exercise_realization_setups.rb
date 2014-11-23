class CreateExerciseRealizationSetups < ActiveRecord::Migration
  def change
    create_table :exercise_realization_setups do |t|
      t.string :exercise_setup_code
    end
  end
end
