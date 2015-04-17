class Unit < ActiveRecord::Base
  UNIT_TYPES = [:integer, :decimal, :time, :string]

  self.primary_key = :code
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code

  # =================== ASSOCIATIONS =================================
  has_many :exercise_setups, :foreign_key => :unit_code
  has_many :exercise_measurements, :foreign_key => :unit_code

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, uniqueness: true
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
  def unit_type=(unit_type)
    write_attribute(:unit_type, unit_type.to_s) unless unit_type.blank?
  end
  # =================== METHODS ======================================
  def to_s
    self.name.to_s
  end

  def to_s_complete
    str = self.name
    str+=" ["+self.abbreviation+"]" unless self.abbreviation.blank?
    str
  end

  # Destroy validation
  def destroy
    raise 'Unit is in use and therefore can\'t be deleted' if (!exercise_setups.empty? || !exercise_measurements.empty?)
    super
  end
end