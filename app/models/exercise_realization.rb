class ExerciseRealization < ActiveRecord::Base
  include RankedModel
  # Order can only be updated with update_attribute :row_order_position,
  # this call saves the record to DB, beware of that when creating instances, etc.
  ranks :row_order, :with_same => :plan_id

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
  # Allow virtual time attributes for duration and rest_after, total time in seconds is calculated from this before save
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
  validates :time_duration, numericality: {greater_than_or_equal_to: 1} # has to have a positive value, unless has sets
  validates :time_duration, presence: true, unless: Proc.new { |realization| realization.exercise.has_sets? } # ignore if has sets
  validates :rest_after, numericality: {greater_than_or_equal_to: 0} # optional, default 0
  validate :fits_into_lesson

  # =================== METHODS ======================================
  # Returns cloned version of self, a deep clone is made with associations
  def deep_clone(new_plan, new_position)
    # Do a deep clone
    er = self.dup
    er.plan = new_plan
    er.update_attribute :row_order_position, new_position # This also saves the er
    # Default values are created in callback, so destroy them
    er.exercise_realization_setups.destroy_all
    er.exercise_set_realizations.destroy_all
    # Add setups & sets & set setups
    self.exercise_realization_setups.each do |ers|
      cloned_ers = ers.dup
      cloned_ers.exercise_realization = er
      cloned_ers.save
    end
    self.exercise_set_realizations.rank(:row_order).each_with_index do |esr, esr_index|
      cloned_esr = esr.dup
      cloned_esr.exercise_realization = er
      cloned_esr.update_attribute :row_order_position, esr_index
      esr.exercise_set_realization_setups.each do |esrs|
        esrs_cloned = esrs.dup
        esrs_cloned.exercise_set_realization = cloned_esr
        esrs_cloned.save
        puts esrs_cloned.inspect
      end
      cloned_esr.save
    end
    er.rest_after = self.rest_after
    er.save
    # Return cloned realization
    er
  end

  # Return actual position within plan based on row order param (RankedModel)
  # @return [integer] Position within plan
  def position
    self.plan.exercise_realizations.rank(:row_order).index(self)
  end

  # Get total duration of the exercise, counts with exercise sets
  # @param p
  #   Optional parameter p is used to get a modified set
  # @return [integer] Total current time of the realization in seconds without rest_after
  def duration(*p)
    if !self.exercise.has_sets?
      self[:time_duration]
    elsif self.exercise.has_sets?
      total = 0
      if p.any?
        self.exercise_set_realizations.reject{|a| a==p[0]}.each do |esr|
          total+=esr.duration+esr.rest_after
        end
        total+=p[0].duration+p[0].rest_after
      else
        self.exercise_set_realizations.each do |esr|
          total+=esr.duration+esr.rest_after
        end
      end
      total
    end
  end

  # Returns realization start time in seconds
  # @return [integer] ExerciseRealization start time in seconds
  def from
    realizations_preceding = self.plan.exercise_realizations.rank(:row_order).take_while { |e| e.row_order < self.row_order }
    time = 0
    realizations_preceding.each do |rp|
      time+=rp.duration+rp.rest_after
    end
    self.plan.training_lesson_realization.from+time
  end

  # Returns realization end time in seconds WITHOUT rest time
  # @return [integer] ExerciseRealization end time in seconds without rest after
  def until
    self.from+duration
  end

  # Returns realization end time in seconds WITH rest time
  # @return [integer] ExerciseRealization end time in seconds with rest after
  def until_with_rest_time
    self.until+self.rest_after
  end

  # Validate if the sum of used time by realizations is <= the maximal available time (defined in TrainingLessonRealization)
  # @param p
  #   Optional parameter p is used to get a modified set
  # self.plan.exercise_realizations returns only persisted values (TODO why?),
  # so the validation did not work for modified values, currently using this workaround with optional parameter p, see ExerciseRealization#duration
  # It is bad design, but currently the easiest workaround
  # @return [boolean] Does edited realization fit into its plan?
  def fits_into_lesson(*p)
    unless self.plan.blank? || self.plan.training_lesson_realization.blank?
      total = 0
      # Get current total duration (including rest and sets), but without the modified values
      self.plan.exercise_realizations.reject{|a| a==self}.each do |er|
        total += er.duration + er.rest_after
      end
      # If modified set was received, pass it to duration to check if the overall duration is OK
      p.any? ? total += duration(p[0])+self[:rest_after] : total += duration+self[:rest_after]
      if total>self.plan.training_lesson_realization.lesson_length(:second)
        errors.add(:time_duration, I18n.t('exercise_realizations.error.doesnt_fit_into_lesson'))
        return false
      end
      true
    end
  end

  # =================== GETTERS/SETTERS ===============================
  # Getters for virtual duration/rest_after attributes
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
      ActiveRecord::Base.transaction do
        self.exercise.exercise_setups.type('simple_setups').required.each do |es|
          ExerciseRealizationSetup.create(:exercise_realization_id => self.id, :exercise_setup_code => es.code, :numeric_value => 0)
        end
      end
    end

    # Create and add one exercise set if exercise is ExerciseWithSets
    def set_exercise_set_if_required
      if self.exercise.has_sets? && self.exercise_set_realizations.empty?
        ExerciseSetRealization.create!(:exercise_realization_id=>self.id,:row_order=>0,:time_duration=>60)
      end
    end

    # Computes and saves time duration from given partial times
    def set_time_duration
      unless self.exercise.has_sets? && (@duration_partial_hours.blank? && @duration_partial_minutes.blank? && @duration_partial_seconds.blank?)
        self.time_duration = (@duration_partial_hours.to_i*3600+@duration_partial_minutes.to_i*60+@duration_partial_seconds.to_i)
      end
    end

    def set_rest_after
      unless @rest_partial_minutes.blank? && @rest_partial_seconds.blank?
        self[:rest_after] = (@rest_partial_minutes.to_i*60+@rest_partial_seconds.to_i)
      end
    end
end