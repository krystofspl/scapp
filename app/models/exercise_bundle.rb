class ExerciseBundle < ActiveRecord::Base
  ACCESSIBILITY = %w('private','global')

  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  belongs_to :user
  has_many :exercises, :through => :ExerciseBundleExercise

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
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

end