class ExerciseSetupType < ActiveRecord::Base

  self.primary_key = :code
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  has_one :exercise_setup

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end