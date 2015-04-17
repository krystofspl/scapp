class Plan < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :training_lesson_realization
  belongs_to :user_created, :class_name => 'User'
  belongs_to :user_partook, :class_name => 'User'
  has_many :exercise_realizations, :inverse_of => :plan, :dependent => :destroy
  has_many :favorite_plans # Favorite plan is connected here => I am a clone
  # =================== SCOPES =======================================
  scope :from_lesson, -> (training_lesson_realization) { where 'plans.training_lesson_realization_id = ?', training_lesson_realization.id}
  scope :sort_by_username, -> { joins(:user_partook).order('users.last_name, users.first_name') }
  scope :accessible, -> (training_lesson_realization, user) {
    if user.is_admin?
      where(true)
    elsif user.is_coach?
      where(training_lesson_realization.has_coach? user)
    elsif user.is_player?
      where(:user_partook=>user)
    else nil
    end
  }
  # =================== METHODS ======================================
  # Return realizations for this plan ordered
  def realizations_ordered
    self.exercise_realizations.rank(:row_order)
  end

  def duration
    total = 0
    self.exercise_realizations.each do |r|
      total+=r.duration+r.rest_after
    end
    total
  end

  # Return remaining time for plan in seconds
  def remaining_time
    if self.exercise_realizations.empty?
      training_lesson_realization.lesson_length(:second)
    else
      self.training_lesson_realization.until.to_i-realizations_ordered.last.until_with_rest_time.to_i
    end
  end

  # Return progress of plan (how full it is)
  def progress_in_percent
    100-(100*remaining_time/self.training_lesson_realization.lesson_length(:second))
  end

  def is_empty?
    self.exercise_realizations.empty?
  end

  def deep_clone
    # Couldn't get it to work with amoeba or deep_cloneable, so it's done manually
    cloned_plan = nil
    ActiveRecord::Base.transaction do
      cloned_plan = self.dup
      cloned_plan.user_partook = nil
      cloned_plan.training_lesson_realization = nil
      self.exercise_realizations.rank(:row_order).each_with_index do |er, er_index|
        er.deep_clone(cloned_plan,er_index)
      end
      cloned_plan.save
    end
    cloned_plan
  end
end
