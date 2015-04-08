class Plan < ActiveRecord::Base
  # =================== ASSOCIATIONS =================================
  belongs_to :training_lesson_realization
  belongs_to :user_created, :class_name => 'User'
  belongs_to :user_partook, :class_name => 'User'
  has_many :exercise_realizations, :inverse_of => :plan
  has_many :favorite_plans
  # =================== SCOPES =======================================
  default_scope {joins(:user_partook).order('users.last_name, users.first_name')}
  scope :from_lesson, -> (training_lesson_realization) { where 'plans.training_lesson_realization_id = ?', training_lesson_realization.id}

  # =================== GETTERS ======================================
  # Return realizations for this plan ordered
  def realizations_ordered
    self.exercise_realizations.rank(:order)
  end

  # Return remaining time for plan in seconds
  def remaining_time
    if self.exercise_realizations.empty?
      training_lesson_realization.lesson_length(:second)
    else
      self.training_lesson_realization.until.to_i-realizations_ordered.last.until_with_rest_time.to_i
    end
  end

end
