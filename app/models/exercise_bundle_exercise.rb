class ExerciseBundleExercise < ActiveRecord::Base
  belongs_to :exercise, :class_name => 'Exercise', :foreign_key => [:exercise_code, :exercise_version]
  belongs_to :exercise_bundle, :class_name => 'ExerciseBundle', :foreign_key => :exercise_bundle_code
end