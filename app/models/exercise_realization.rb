# Order can only be updated with update_attribute :order_position,
# this call saves the record to DB, beware of that when creating instances, etc.

class ExerciseRealization < ActiveRecord::Base
  include RankedModel
  ranks :order, :with_same => :plan_id
  before_validation do
    unless self.new_record?
      set_time_duration
      set_rest_after
    end
  end
  after_create do
    set_required_realization_setups
    set_exercise_set_if_required
  end
  attr_writer :duration_partial_hours, :duration_partial_minutes, :duration_partial_seconds, :rest_partial_minutes, :rest_partial_seconds

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version], :inverse_of => :exercise_realizations
  belongs_to :user_measured, :class_name => 'User'
  belongs_to :user_created, :class_name => 'User'
  belongs_to :plan, :inverse_of => :exercise_realizations
  has_many :exercise_realization_setups, :dependent => :destroy
  has_many :exercise_realization_measurements
  has_many :exercise_set_realizations, :inverse_of => :exercise_realization, :dependent => :destroy

  # =================== VALIDATIONS ==================================
  validates :user_created, presence: true
  validates :plan_id, presence: true
  validates :time_duration, numericality: {greater_than_or_equal_to: 1}
  validates :time_duration, presence: true, unless: Proc.new { |realization| realization.exercise.has_sets? }
  validates :rest_after, numericality: {greater_than_or_equal_to: 0}
  validate :fits_into_lesson

  # =================== METHODS ======================================
  # Return position based on row order (RankedModel)
  def position
    self.exercise.exercise_realizations.rank(:order).index(self)
  end

  # Get total duration of the exercise, counts with exercise sets
  def duration
    if !self.exercise.has_sets?
      self[:time_duration]
    elsif self.exercise.has_sets?
      total = 0
      self.exercise_set_realizations.all.each do |esr|
        total+=esr.duration+esr.rest_after
      end
      total
    end
  end

  # Returns realization start time in seconds
  def from
    realizations_preceding = self.plan.exercise_realizations.rank(:order).take_while { |e| e.order < self.order }
    time = 0
    realizations_preceding.each do |rp|
      time+=rp.duration+rp.rest_after
    end
    self.plan.training_lesson_realization.from+time
  end

  # Returns realization end time in seconds WITHOUT rest time
  def until
    self.from+duration
  end

  # Returns realization end time in seconds WITH rest time
  def until_with_rest_time
    self.until+self.rest_after
  end

  # Validate if the sum of used time by realizations is <= the maximal available time (defined in TrainingLessonRealization)
  #TODO fix this - can't obtain current updated value, it is loaded from DB instead, crucial for ExerciseSetRealizations
  def fits_into_lesson
    unless self.plan.blank? || self.plan.training_lesson_realization.blank?
      total = 0
      # Get current total duration (including rest and sets)
      self.plan.exercise_realizations.reject{|a| a==self}.each do |er| # FIX FIX FIX FIX
        total += er.duration + er.rest_after
      end
      total += duration+self[:rest_after] # FIX FIX FIX FIX
      if total>self.plan.training_lesson_realization.lesson_length(:second)
        errors.add(:time_duration, I18n.t('exercise_realizations.error.doesnt_fit_into_lesson'))
        return false
      end
      true
    end
  end

  # =================== GETTERS/SETTERS ===============================
  def duration_partial_hours
    read_attribute(:time_duration)/3600
  end

  def duration_partial_minutes
    (read_attribute(:time_duration)-duration_partial_hours*3600)/60
  end

  def duration_partial_seconds
    read_attribute(:time_duration)%60
  end

  def rest_partial_minutes
    read_attribute(:rest_after)/60
  end

  def rest_partial_seconds
    read_attribute(:rest_after)%60
  end

  private
    # Create and add all required exercise setups
    def set_required_realization_setups
      self.exercise.exercise_setups.type('simple_setups').required.each do |es|
        ExerciseRealizationSetup.create(:exercise_realization_id => self.id, :exercise_setup_code => es.code, :numeric_value => 0)
      end
    end

    # Create and add one exercise set if exercise is ExerciseWithSets
    def set_exercise_set_if_required
      if self.exercise.has_sets?
        ExerciseSetRealization.create!(:exercise_realization_id=>self.id,:order=>0,:time_duration=>60)
      end
    end

    # Computes and saves time duration from given partial times
    def set_time_duration
      unless self.exercise.has_sets?
        self[:time_duration] = (@duration_partial_hours.to_i*3600+@duration_partial_minutes.to_i*60+@duration_partial_seconds.to_i)
      end
    end

    def set_rest_after
      self[:rest_after] = (@rest_partial_minutes.to_i*60+@rest_partial_seconds.to_i)
    end
end