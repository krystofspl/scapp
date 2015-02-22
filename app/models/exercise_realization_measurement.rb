class ExerciseRealizationMeasurement < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_measurement, :foreign_key => :exercise_measurement_code, counter_cache: true
end