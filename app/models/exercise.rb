class Exercise < ActiveRecord::Base
  ACCESSIBILITY = [:private, :global]

  self.primary_keys = :code, :version
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  belongs_to :user
  #has_one :exercise_image
  has_many :exercise_bundle_exercises, :class_name => 'ExerciseBundleExercise', :foreign_key => [:exercise_code, :exercise_version]
  has_many :exercise_bundles, :through => :exercise_bundle_exercises
  has_many :exercise_steps, :foreign_key => [:exercise_code, :exercise_version], :dependent => :delete_all
  has_many :exercise_setups, :foreign_key => [:exercise_code, :exercise_version], :dependent => :delete_all
  has_many :exercise_measurements, :foreign_key => [:exercise_code, :exercise_version], :dependent => :delete_all
  # --- prototypes for v2
  has_many :exercise_realizations, :foreign_key => [:exercise_code, :exercise_version], :dependent => :restrict_with_error

  # =================== VALIDATIONS ==================================
  validates :code, presence: true
  validates :version, presence: true
  validates :name, presence: true
  #TODO nefunguje a hází validates :name, uniqueness: true, unless: :version>1
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

  # Return exercise_code(/version/) string
  def relative_url
    read_attribute(:code) + ((read_attribute(:version).to_i>1) ? ("/v/"+read_attribute(:version).to_s) : "")
  end

  # Return exercises/exercise_code(/version/) string
  def url
    "/exercises/#{relative_url}"
  end
end