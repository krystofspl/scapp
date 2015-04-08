class ExerciseSetRealization < ActiveRecord::Base
  include RankedModel
  ranks :order, :with_same => :exercise_realization_id
  before_validation do
    set_time_duration
    set_rest_after
  end
  after_create do
    set_required_set_realization_setups
  end
  attr_writer :duration_partial_minutes, :duration_partial_seconds, :rest_partial_minutes, :rest_partial_seconds

  # =================== ASSOCIATIONS =================================
  belongs_to :exercise_realization, :inverse_of => :exercise_set_realizations
  has_many :exercise_set_realization_setups, :dependent => :destroy

  # =================== VALIDATIONS ==================================
  validates :time_duration, numericality: {greater_than_or_equal_to: 1}
  validates :rest_after, numericality: {greater_than_or_equal_to: 0}
  #validate :fits_into_lesson #TODO FIX, see exercise_realization.rb

  # =================== METHODS ======================================

  # Return position based on row order (RankedModel)
  def position
    self.exercise.exercise_realizations.rank(:order).index(self)
  end

  # Get total duration of the exercise, counts with exercise sets
  def duration
    self[:time_duration]
  end

  # Returns realization start time in seconds
  def from
    realization_sets_preceding = self.exercise_realization.exercise_set_realizations.rank(:order).take_while { |e| e.order < self.order }
    time = 0
    realization_sets_preceding.each do |rp|
      time+=rp.duration+rp.rest_after
    end
    self.exercise_realization.from+time
  end

  # Returns set realization end time in seconds WITHOUT rest time
  def until
    from+duration
  end

  # Returns set realization end time in seconds WITH rest time
  def until_with_rest_time
    self.until+self[:rest_after]
  end

  # Validate if the sum of used time by realizations is <= the maximal available time (defined in TrainingLessonRealization)
  def fits_into_lesson
    unless self.exercise_realization.fits_into_lesson
      errors.add(:time_duration, I18n.t('exercise_realizations.error.doesnt_fit_into_lesson'))
    end
  end
  # =================== GETTERS/SETTERS ===============================
  def duration_partial_minutes
    read_attribute(:time_duration)/60
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

  def set_time_duration
    unless @duration_partial_minutes.blank? || @duration_partial_seconds.blank?
      self[:time_duration] = (@duration_partial_minutes.to_i*60+@duration_partial_seconds.to_i)
    end
  end

  def set_rest_after
    unless @rest_partial_minutes.blank? || @rest_partial_seconds.blank?
      self[:rest_after] = (@rest_partial_minutes.to_i*60+@rest_partial_seconds.to_i)
    end
  end

  private
    def set_required_set_realization_setups
      self.exercise_realization.exercise.exercise_setups.type('set_setups').required.each do |es|
        ExerciseSetRealizationSetup.create(:exercise_set_realization_id => self.id, :exercise_setup_code => es.code, :numeric_value => 0)
      end
    end
end