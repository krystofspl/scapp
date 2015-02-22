class ExerciseRealization < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version], counter_cache: true
end