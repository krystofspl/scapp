class ExerciseSetupType < ActiveRecord::Base

  self.primary_key = :code
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  has_many :exercise_setups, :foreign_key => :exercise_setup_type_code

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  # =================== METHODS ==================================
  def to_s
    read_attribute(:name).to_s
  end
end