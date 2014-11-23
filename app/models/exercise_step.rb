class ExerciseStep < ActiveRecord::Base
  include RankedModel
  ranks :row_order

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_images

  # =================== VALIDATIONS =================================
  validates :name, presence: true
  validates :row_order, presence: true

  # =================== GETTERS / SETTERS ============================

end
