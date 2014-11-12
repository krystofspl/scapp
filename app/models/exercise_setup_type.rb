class ExerciseSetupType < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  has_one :exercise_setup

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end