class ExerciseWithSets < Exercise
  has_many :exercise_set_setups, :foreign_key => [:exercise_code, :exercise_version], :dependent => :destroy

  def self.model_name
    Exercise.model_name
  end
end