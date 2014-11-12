class ExerciseSetup < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_setup_type
  belongs_to :unit
  belongs_to :exercise

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :required, presence: true

  # =================== GETTERS / SETTERS ============================
end
