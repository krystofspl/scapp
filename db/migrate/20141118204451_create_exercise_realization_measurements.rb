class CreateExerciseRealizationMeasurements < ActiveRecord::Migration
  def change
    create_table :exercise_realization_measurements do |t|
      t.string :exercise_measurement_code
    end
  end
end
