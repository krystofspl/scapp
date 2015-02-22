class ExerciseRealizationSetup < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_setup, :foreign_key => :exercise_setup_code, counter_cache: true
end