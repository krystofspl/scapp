class ExerciseRealizationSetup < ActiveRecord::Base
  before_destroy :check_if_required
  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_setup, :foreign_key => :exercise_setup_code, counter_cache: true
  belongs_to :exercise_realization

  # =================== VALIDATIONS ==================================
  validate :string_xor_numeric
  validates :exercise_setup_code, presence: true
  validates :exercise_realization_id, presence: true
  validates :numeric_value, numericality: true

  # =================== METHODS ==================================
  def value
    if !self.numeric_value.blank?
      if self.exercise_setup.unit.unit_type == :integer
        self.numeric_value.to_i
      elsif self.exercise_setup.unit.unit_type == :decimal
        self.numeric_value
      end
    elsif !self.string_value.blank?
      self.string_value
    else
      ""
    end
  end

  private
    def string_xor_numeric
      unless self.string_value.blank? ^ self.numeric_value.blank?
        errors.add(:base, 'Either numeric or string value must be filled in')
      end
    end
    def check_if_required
      if self.exercise_setup.is_required?
        errors[:base] << t('exercise_realization_setups.errors.cannot_delete_required')
        false
      end
    end
end