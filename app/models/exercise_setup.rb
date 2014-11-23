class ExerciseSetup < ActiveRecord::Base

  self.primary_key = :code
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_setup_type, :foreign_key => :exercise_setup_type_code
  belongs_to :unit, :foreign_key => :unit_code
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version]
  # --- prototypes for v2
  has_many :exercise_realization_setups, :foreign_key => :exercise_setup_code

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :required, inclusion: { in: [true,false]}

  # =================== GETTERS / SETTERS ============================

  # =================== HELPERS ======================================
  def is_required?
    self.read_attribute(:required)
  end

  # Does the exercise setup have any realizations?
  def is_in_use?
    !self.exercise_realization_setups.empty?
  end
end
