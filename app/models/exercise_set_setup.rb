class ExerciseSetSetup < ExerciseSetup
  has_many :exercise_set_realization_setups
  belongs_to :exercise_with_sets, :foreign_key => [:exercise_code, :exercise_version]
  # Fix for URLs
  def self.model_name
    ExerciseSetup.model_name
  end
end