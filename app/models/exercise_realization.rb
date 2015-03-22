class ExerciseRealization < ActiveRecord::Base
  include RankedModel
  ranks :order, :with_same => :plan_id
  before_validation do
    set_time_duration
    set_rest_after
  end

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise, :foreign_key => [:exercise_code, :exercise_version]
  belongs_to :user_measured, :class_name => 'User'
  belongs_to :user_created, :class_name => 'User'
  belongs_to :plan
  has_many :exercise_realization_setups
  has_many :exercise_realization_measurements

  # =================== VALIDATIONS ==================================
  validates :user_created, presence: true
  validates :plan_id, presence: true
  validates :time_duration, numericality: {greater_than: 5}
  validates :rest_after, numericality: true
  validates :order, presence: true
  validate :fits_into_lesson

  # =================== METHODS ======================================
  # Return position based on row order (RankedModel)
  def position
    self.exercise.exercise_realizations.rank(:order).index(self)
  end

  def from
    realizations_preceding = self.plan.exercise_realizations.rank(:order).take_while { |e| e.order < self.order }
    time = 0
    realizations_preceding.each do |rp|
      time+=rp.time_duration
      time+=rp.rest_after
    end
    self.plan.training_lesson_realization.from+time
  end

  def until
    self.from+read_attribute(:time_duration)
  end

  def until_with_rest_time
    self.until+read_attribute(:rest_after)
  end

  # Validate if the sum of used time by realizations is <= the maximal available time (defined in TrainingLessonRealization)
  def fits_into_lesson
    unless self.plan.blank? || self.plan.training_lesson_realization.blank?
      total = 0
      self.plan.exercise_realizations.where.not(id:self.id).each do |er|
        total += er.time_duration + er.rest_after
      end
      total += read_attribute(:time_duration)+read_attribute(:rest_after)
      if total>self.plan.training_lesson_realization.lesson_length*3600
        errors.add(:time_duration, I18n.t('exercise_realizations.error.doesnt_fit_into_lesson'))
      end
    end
  end

  # =================== GETTERS/SETTERS ===============================
  #TODO jak tohle zkrátit/zlepšit?
  def duration_partial_hours
    self.time_duration/3600
  end

  def duration_partial_hours=(duration)
    @duration_partial_hours = duration
  end

  def duration_partial_minutes
    (self.time_duration-duration_partial_hours*3600)/60
  end

  def duration_partial_minutes=(duration)
    @duration_partial_minutes = duration
  end

  def duration_partial_seconds
    self.time_duration%60
  end

  def duration_partial_seconds=(duration)
    @duration_partial_seconds = duration
  end

  def rest_partial_minutes
    self.rest_after/60
  end

  def rest_partial_minutes=(duration)
    @rest_partial_minutes = duration
  end

  def rest_partial_seconds
    self.rest_after%60
  end

  def rest_partial_seconds=(duration)
    @rest_partial_seconds = duration
  end

  def set_time_duration
    unless @duration_partial_hours.blank? || @duration_partial_minutes.blank? || @duration_partial_seconds.blank?
      write_attribute(:time_duration, (@duration_partial_hours.to_i*3600+@duration_partial_minutes.to_i*60+@duration_partial_seconds.to_i))
    end
  end

  def set_rest_after
    unless @rest_partial_minutes.blank? || @rest_partial_seconds.blank?
      write_attribute(:rest_after, (@rest_partial_minutes.to_i*60+@rest_partial_seconds.to_i))
    end
  end
end