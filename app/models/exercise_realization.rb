class ExerciseRealization < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version]
end