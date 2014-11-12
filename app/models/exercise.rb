class Exercise < ActiveRecord::Base
  ACCESSIBILITY = %w('private','global')

  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  belongs_to :user
  has_one :exercise_image
  has_many :exercise_bundles, :through => :exercise_bundle_exercise
  has_many :exercise_steps

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
end