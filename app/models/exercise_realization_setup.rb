class ExerciseRealizationSetup < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_setup, :foreign_key => :exercise_setup_code, counter_cache: true
  belongs_to :exercise_realization

  # =================== VALIDATIONS ==================================
  validate :string_xor_numeric

  private
    def string_xor_numeric
      unless :string_value.blank? ^ :numeric_value.blank?
        errors.add(:base, 'Either numeric or string value must be filled up')
      end
    end
end