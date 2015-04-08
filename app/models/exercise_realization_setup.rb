class ExerciseRealizationSetup < ActiveRecord::Base
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

  # Checks if setup for current realization is required
  def is_required?
    if self.exercise_setup.is_required?
      errors.add(:base, I18n.t('exercise_realization_setups.errors.cannot_delete_required'))
      false
    end
  end

  private
    def string_xor_numeric
      unless self.string_value.blank? ^ self.numeric_value.blank?
        errors.add(:base, I18n.t('exercise_realization_setups.errors.value_must_be_filled_in'))
      end
    end
end