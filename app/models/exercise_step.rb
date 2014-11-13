class ExerciseStep < ActiveRecord::Base

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_images

  # =================== VALIDATIONS =================================
  validates :name, presence: true
  validates :step_number, presence: true

  # =================== GETTERS / SETTERS ============================

end
