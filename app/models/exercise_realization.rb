class ExerciseRealization < ActiveRecord::Base
  include RankedModel
  ranks :order, :with_same => :plan

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version], counter_cache: true
  belongs_to :user_measured, :class_name => 'User'
  belongs_to :user_created, :class_name => 'User'
  belongs_to :plan
  has_many :exercise_realization_setups
  has_many :exercise_realization_measurements

  # =================== VALIDATIONS ==================================
  validates :user_created, presence: true
  validates :user_measured, presence: true
  validates :plan_id, presence: true
  validates :time_duration, presence: true, numericality: true
  validates :rest_after, numericality: true
  validates :order, presence: true

  # =================== METHODS ======================================
  # Return position based on row order (RankedModel)
  def get_position
    self.exercise.exercise_realizations.rank(:order).index(self)
  end
end