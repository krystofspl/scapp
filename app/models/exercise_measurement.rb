class ExerciseMeasurement < ActiveRecord::Base
  OPTIMAL_VALUES = [:higher, :lower]

  self.primary_key = :code
  extend FriendlyId
  friendly_id :name, :use => :slugged, :slug_column => :code
  
  # =================== ASSOCIATIONS =================================
  belongs_to :unit, :foreign_key => :unit_code
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version]

  # =================== VALIDATIONS ==================================
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :optimal_value, inclusion: { in: OPTIMAL_VALUES }
  # =================== GETTERS / SETTERS ============================

  # Read optimal_value
  # @return [Symbol] optimal_value
  def optimal_value
    read_attribute(:optimal_value).to_sym unless read_attribute(:optimal_value).blank?
  end

  # Set optimal_value
  # @param optimal_value
  #   @option :higher
  #   @option :lower
  def optimal_value=(optimal_value)
    write_attribute(:optimal_value, optimal_value.to_s) unless optimal_value.blank?
  end

end
