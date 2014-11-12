class ExerciseStep < ActiveRecord::Base

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise
  has_many :exercise_images

  # =================== VALIDATIONS =================================
  validates :name, presence: true
  validates :step_number, presence: true

  # =================== GETTERS / SETTERS ============================

end
