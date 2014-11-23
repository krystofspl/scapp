class Exercise < ActiveRecord::Base
  ACCESSIBILITY = [:private, :global]

  self.primary_keys = :code, :version
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code
  #TODO validovat code ve formulari (uniqueness, aby se nepřidal UUID)

  # =================== ASSOCIATIONS =================================
  belongs_to :user
  has_one :exercise_image
  has_many :exercise_bundle_exercises, :class_name => 'ExerciseBundleExercise', :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_bundles, :through => :exercise_bundle_exercises
  has_many :exercise_steps, :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_setups, :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_measurements, :foreign_key => [:exercise_code, :exercise_version]
  # --- prototypes for v2
  has_many :exercise_realizations, :foreign_key => [:exercise_code, :exercise_version]


  # =================== VALIDATIONS ==================================
  validates :code, presence: true
  validates :version, presence: true
  validates :name, presence: true
  validates :accessibility, inclusion: { in: ACCESSIBILITY }

  # =================== GETTERS / SETTERS ============================

  # Read accessibility
  # @return [Symbol] accessibility
  def accessibility
    read_attribute(:accessibility).to_sym unless read_attribute(:accessibility).blank?
  end

  # Set accessibility
  # @param accessibility
  #   @option :private
  #   @option :global
  def accessibility=(accessibility)
    write_attribute(:accessibility, accessibility.to_s) unless accessibility.blank?
  end

  # =================== METHODS ======================================
  # Does the exercise have any realizations?
  def is_in_use?
    !self.exercise_realizations.empty?
  end
end