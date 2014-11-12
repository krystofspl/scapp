class ExerciseBundleExercise < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :exercise_bundle
end