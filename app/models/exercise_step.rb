class ExerciseStep < ActiveRecord::Base
  include RankedModel
  ranks :row_order, :with_same => [:exercise_code, :exercise_version]

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_images, :dependent => :delete_all
  accepts_nested_attributes_for :exercise_images, allow_destroy: true

  # =================== VALIDATIONS =================================
  validates :name, presence: true
  validates :row_order, presence: true

  # =================== GETTERS / SETTERS ============================

end
