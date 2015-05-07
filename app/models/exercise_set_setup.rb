class ExerciseSetSetup < ExerciseSetup
  has_many :exercise_set_realization_setups
  belongs_to :exercise_with_sets, :foreign_key => [:exercise_code, :exercise_version]

  # =================== METHODS ============================
  # Fix for URLs - override model name
  def self.model_name
    ExerciseSetup.model_name
  end
end