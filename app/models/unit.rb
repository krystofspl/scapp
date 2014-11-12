class Unit < ActiveRecord::Base
  UNIT_TYPES = %w('integer','decimal','time')

  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  has_many :exercise_setups
  has_many :exercise_measurements

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :abbreviation, presence: true, uniqueness: true
  validates :unit_type, inclusion: { in: UNIT_TYPES }

  # =================== GETTERS / SETTERS ============================
  # Read unit_type
  # @return [Symbol] unit_type
  def unit_type
    read_attribute(:unit_type).to_sym unless read_attribute(:unit_type).blank?
  end

  # Set unit_type
  # @param unit_type
  #   @option :integer
  #   @option :decimal
  #   @option :time
  def unit_type(unit_type)
    write_attribute(:unit_type, accessibility.to_s) unless unit_type.blank?
  end
  # =================== METHODS ======================================
end